//
//  FocusMusicManager.swift
//  FocusHabit
//
//  专注音乐管理器 - 管理 Apple Music 和白噪音播放
//

import Foundation
import AVFoundation
import MusicKit
import MediaPlayer

/// 白噪音类型
enum WhiteNoiseType: String, CaseIterable, Identifiable {
    case forest = "forest"
    case rain = "rain"
    case ocean = "ocean"
    case crickets = "crickets"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .forest: return L10n.whiteNoiseForest
        case .rain: return L10n.whiteNoiseRain
        case .ocean: return L10n.whiteNoiseOcean
        case .crickets: return L10n.whiteNoiseCrickets
        }
    }
    
    var icon: String {
        switch self {
        case .forest: return "leaf.fill"
        case .rain: return "cloud.rain.fill"
        case .ocean: return "water.waves"
        case .crickets: return "ant.fill"
        }
    }
    
    /// 音频文件名（不含扩展名）
    var fileName: String { rawValue }
}

/// 音乐来源
enum MusicSource: Equatable {
    case none
    case whiteNoise(WhiteNoiseType)
    case appleMusic
}

/// Apple Music 授权状态
enum AppleMusicAuthStatus {
    case notDetermined
    case authorized
    case denied
    case restricted
    
    var displayText: String {
        switch self {
        case .notDetermined: return L10n.appleMusicNotConnected
        case .authorized: return L10n.appleMusicConnected
        case .denied: return L10n.appleMusicDenied
        case .restricted: return L10n.appleMusicRestricted
        }
    }
}

/// 专注音乐管理器
@Observable
final class FocusMusicManager {
    
    // MARK: - Singleton
    
    static let shared = FocusMusicManager()
    
    // MARK: - Public State
    
    /// 是否启用音乐功能
    var isMusicEnabled: Bool = false {
        didSet {
            if !isMusicEnabled {
                stopAll()
            }
        }
    }
    
    /// 当前音乐来源
    private(set) var currentSource: MusicSource = .none
    
    /// 是否正在播放
    private(set) var isPlaying: Bool = false
    
    /// 音量 (0.0 - 1.0)
    var volume: Float = 0.7 {
        didSet {
            whiteNoisePlayer?.volume = volume
            // Apple Music 音量由系统控制
        }
    }
    
    /// Apple Music 授权状态
    private(set) var appleMusicAuthStatus: AppleMusicAuthStatus = .notDetermined
    
    /// Apple Music 当前播放曲目
    private(set) var appleMusicNowPlaying: String?
    
    /// Apple Music 当前艺术家
    private(set) var appleMusicArtist: String?
    
    /// Apple Music 当前封面
    private(set) var appleMusicArtwork: Artwork?
    
    // MARK: - Private
    
    private var whiteNoisePlayer: AVAudioPlayer?
    private let appleMusicPlayer = ApplicationMusicPlayer.shared
    private var musicStateObservation: Task<Void, Never>?
    
    // MARK: - Init
    
    private init() {
        setupAudioSession()
        checkAppleMusicAuthStatus()
        observeAppleMusicState()
    }
    
    deinit {
        musicStateObservation?.cancel()
    }
    
    // MARK: - Audio Session
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Apple Music Authorization
    
    private func checkAppleMusicAuthStatus() {
        let status = MusicAuthorization.currentStatus
        updateAuthStatus(status)
    }
    
    private func updateAuthStatus(_ status: MusicAuthorization.Status) {
        switch status {
        case .notDetermined:
            appleMusicAuthStatus = .notDetermined
        case .authorized:
            appleMusicAuthStatus = .authorized
        case .denied:
            appleMusicAuthStatus = .denied
        case .restricted:
            appleMusicAuthStatus = .restricted
        @unknown default:
            appleMusicAuthStatus = .notDetermined
        }
    }
    
    @MainActor
    func requestAppleMusicAuthorization() async {
        let status = await MusicAuthorization.request()
        updateAuthStatus(status)
    }
    
    // MARK: - Apple Music State Observer
    
    private func observeAppleMusicState() {
        musicStateObservation = Task { @MainActor [weak self] in
            for await _ in ApplicationMusicPlayer.shared.state.objectWillChange.values {
                guard let self = self else { return }
                self.updateAppleMusicState()
            }
        }
        Task { @MainActor in
            updateAppleMusicState()
        }
    }
    
    @MainActor
    private func updateAppleMusicState() {
        guard case .appleMusic = currentSource else { return }
        
        let state = appleMusicPlayer.state
        isPlaying = state.playbackStatus == .playing
        
        if let entry = appleMusicPlayer.queue.currentEntry {
            switch entry.item {
            case .song(let song):
                appleMusicNowPlaying = song.title
                appleMusicArtist = song.artistName
                appleMusicArtwork = song.artwork
            default:
                appleMusicNowPlaying = entry.title
                appleMusicArtist = nil
                appleMusicArtwork = entry.artwork
            }
        }
    }
    
    // MARK: - White Noise Playback
    
    func playWhiteNoise(_ type: WhiteNoiseType) {
        // 停止其他音源
        stopAppleMusic()
        stopWhiteNoise()
        
        // 查找音频文件
        guard let url = Bundle.main.url(forResource: type.fileName, withExtension: "mp3")
                ?? Bundle.main.url(forResource: type.fileName, withExtension: "m4a")
                ?? Bundle.main.url(forResource: type.fileName, withExtension: "wav") else {
            print("White noise file not found: \(type.fileName)")
            return
        }
        
        do {
            whiteNoisePlayer = try AVAudioPlayer(contentsOf: url)
            whiteNoisePlayer?.numberOfLoops = -1 // 无限循环
            whiteNoisePlayer?.volume = volume
            whiteNoisePlayer?.play()
            
            currentSource = .whiteNoise(type)
            isPlaying = true
        } catch {
            print("Failed to play white noise: \(error)")
        }
    }
    
    func stopWhiteNoise() {
        whiteNoisePlayer?.stop()
        whiteNoisePlayer = nil
        
        if case .whiteNoise = currentSource {
            currentSource = .none
            isPlaying = false
        }
    }
    
    // MARK: - Apple Music Playback
    
    @MainActor
    func setQueue<T: PlayableMusicItem>(_ items: [T]) async {
        appleMusicPlayer.queue = ApplicationMusicPlayer.Queue(for: items)
    }
    
    @MainActor
    func playAppleMusic() async {
        // 停止其他音源
        stopWhiteNoise()
        
        do {
            try await appleMusicPlayer.play()
            currentSource = .appleMusic
            isPlaying = true
            updateAppleMusicState()
        } catch {
            print("Failed to play Apple Music: \(error)")
        }
    }
    
    func stopAppleMusic() {
        appleMusicPlayer.stop()
        
        if case .appleMusic = currentSource {
            currentSource = .none
            isPlaying = false
            appleMusicNowPlaying = nil
            appleMusicArtist = nil
        }
    }
    
    // MARK: - Playback Control
    
    func togglePlayPause() {
        switch currentSource {
        case .none:
            break
        case .whiteNoise:
            if isPlaying {
                whiteNoisePlayer?.pause()
                isPlaying = false
            } else {
                whiteNoisePlayer?.play()
                isPlaying = true
            }
        case .appleMusic:
            Task { @MainActor in
                if isPlaying {
                    appleMusicPlayer.pause()
                    isPlaying = false
                } else {
                    try? await appleMusicPlayer.play()
                    isPlaying = true
                }
            }
        }
    }
    
    /// 播放上一曲（仅 Apple Music）
    func skipToPrevious() {
        guard case .appleMusic = currentSource else { return }
        Task { @MainActor in
            try? await appleMusicPlayer.skipToPreviousEntry()
            updateAppleMusicState()
        }
    }
    
    /// 播放下一曲（仅 Apple Music）
    func skipToNext() {
        guard case .appleMusic = currentSource else { return }
        Task { @MainActor in
            try? await appleMusicPlayer.skipToNextEntry()
            updateAppleMusicState()
        }
    }
    
    func stopAll() {
        stopWhiteNoise()
        stopAppleMusic()
        currentSource = .none
        isPlaying = false
    }
    
    // MARK: - Pause/Resume Control
    
    /// 暂停播放（不清除音源状态）
    func pausePlayback() {
        switch currentSource {
        case .none:
            break
        case .whiteNoise:
            whiteNoisePlayer?.pause()
            isPlaying = false
        case .appleMusic:
            appleMusicPlayer.pause()
            isPlaying = false
        }
    }
    
    /// 恢复播放
    func resumePlayback() {
        switch currentSource {
        case .none:
            break
        case .whiteNoise:
            whiteNoisePlayer?.play()
            isPlaying = true
        case .appleMusic:
            Task { @MainActor in
                try? await appleMusicPlayer.play()
                isPlaying = true
            }
        }
    }
    
    // MARK: - Focus Session Integration
    
    /// 专注开始时调用 - 恢复之前暂停的音乐
    func handleFocusStarted() {
        // 如果有活跃的音源但处于暂停状态，则恢复播放
        if currentSource != .none && !isPlaying {
            resumePlayback()
        }
    }
    
    /// 专注结束时调用 - 根据设置停止或暂停音乐
    func handleFocusEnded() {
        let settings = AppSettings.shared
        if settings.stopMusicOnFocusEnd {
            // 完全停止，清除音源状态
            stopAll()
        } else {
            // 仅暂停，保留音源状态以便恢复
            pausePlayback()
        }
    }
    
    /// 休息结束时调用 - 如果即将开始新的专注，恢复音乐
    func handleBreakEnded() {
        // 休息结束后，音乐状态会在下一次专注开始时由 handleFocusStarted 处理
        // 这里不需要额外操作
    }
}
