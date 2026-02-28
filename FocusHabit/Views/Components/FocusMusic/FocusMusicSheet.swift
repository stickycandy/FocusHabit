//
//  FocusMusicSheet.swift
//  FocusHabit
//
//  专注音乐面板 - 音乐和白噪音选择界面
//

import SwiftUI
import MusicKit

/// 专注音乐面板
struct FocusMusicSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var musicManager = FocusMusicManager.shared
    @State private var showingAppleMusicPicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 音乐开关
                    musicToggleSection
                    
                    if musicManager.isMusicEnabled {
                        // 正在播放
                        nowPlayingSection
                        
                        // Apple Music
                        appleMusicSection
                        
                        // 白噪音
                        whiteNoiseSection
                        
                        // 音量控制
                        volumeSection
                    }
                }
                .padding()
            }
            .navigationTitle(L10n.focusMusic)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.done) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAppleMusicPicker) {
                AppleMusicPickerView()
            }
        }
    }
    
    // MARK: - 音乐开关
    
    private var musicToggleSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.focusMusicEnabled)
                    .font(.headline)
            }
            
            Spacer()
            
            Toggle("", isOn: $musicManager.isMusicEnabled)
                .labelsHidden()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - 正在播放
    
    private var nowPlayingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.nowPlaying)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if musicManager.isPlaying || musicManager.currentSource != .none {
                nowPlayingCard
            } else {
                Text(L10n.selectMusicSource)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var nowPlayingCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                // 封面/图标
                nowPlayingArtwork
                
                // 信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(nowPlayingTitle)
                        .font(.headline)
                        .lineLimit(1)
                    
                    if let subtitle = nowPlayingSubtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
            }
            
            // 播放控制
            playbackControls
        }
    }
    
    @ViewBuilder
    private var nowPlayingArtwork: some View {
        if case .appleMusic = musicManager.currentSource,
           let artwork = musicManager.appleMusicArtwork {
            // Apple Music 专辑封面
            ArtworkImage(artwork, width: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            // 白噪音或默认图标
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .frame(width: 60, height: 60)
                
                nowPlayingIcon
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var playbackControls: some View {
        HStack(spacing: 32) {
            // 上一曲按钮（仅 Apple Music 显示）
            if case .appleMusic = musicManager.currentSource {
                Button {
                    musicManager.skipToPrevious()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
            
            // 播放/暂停按钮
            Button {
                musicManager.togglePlayPause()
            } label: {
                Image(systemName: musicManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
            }
            
            // 下一曲按钮（仅 Apple Music 显示）
            if case .appleMusic = musicManager.currentSource {
                Button {
                    musicManager.skipToNext()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
    
    private var nowPlayingIcon: Image {
        switch musicManager.currentSource {
        case .none:
            return Image(systemName: "music.note")
        case .whiteNoise(let type):
            return Image(systemName: type.icon)
        case .appleMusic:
            return Image(systemName: "music.note")
        }
    }
    
    private var nowPlayingTitle: String {
        switch musicManager.currentSource {
        case .none:
            return L10n.selectMusicSource
        case .whiteNoise(let type):
            return type.displayName
        case .appleMusic:
            return musicManager.appleMusicNowPlaying ?? L10n.appleMusic
        }
    }
    
    private var nowPlayingSubtitle: String? {
        switch musicManager.currentSource {
        case .none:
            return nil
        case .whiteNoise:
            return L10n.whiteNoise
        case .appleMusic:
            return musicManager.appleMusicArtist
        }
    }
    
    // MARK: - Apple Music 区域
    
    private var appleMusicSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.appleMusic)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button {
                handleAppleMusicTap()
            } label: {
                HStack {
                    Image(systemName: "music.note")
                        .font(.title2)
                        .foregroundStyle(.pink)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.appleMusic)
                            .font(.body)
                            .foregroundStyle(.primary)
                        
                        Text(musicManager.appleMusicAuthStatus.displayText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if case .appleMusic = musicManager.currentSource {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.blue)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func handleAppleMusicTap() {
        switch musicManager.appleMusicAuthStatus {
        case .notDetermined:
            Task {
                await musicManager.requestAppleMusicAuthorization()
                if musicManager.appleMusicAuthStatus == .authorized {
                    showingAppleMusicPicker = true
                }
            }
        case .authorized:
            showingAppleMusicPicker = true
        case .denied, .restricted:
            // 引导用户去设置
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    // MARK: - 白噪音区域
    
    private var whiteNoiseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.whiteNoise)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(WhiteNoiseType.allCases) { noise in
                    WhiteNoiseButton(
                        type: noise,
                        isSelected: isNoiseSelected(noise),
                        action: { selectWhiteNoise(noise) }
                    )
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func isNoiseSelected(_ noise: WhiteNoiseType) -> Bool {
        if case .whiteNoise(let selected) = musicManager.currentSource {
            return selected == noise
        }
        return false
    }
    
    private func selectWhiteNoise(_ noise: WhiteNoiseType) {
        if isNoiseSelected(noise) {
            // 取消选择
            musicManager.stopWhiteNoise()
        } else {
            musicManager.playWhiteNoise(noise)
        }
    }
    
    // MARK: - 音量控制
    
    private var volumeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.musicVolume)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                Image(systemName: "speaker.fill")
                    .foregroundStyle(.secondary)
                
                Slider(value: $musicManager.volume, in: 0...1)
                    .tint(.blue)
                
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - 白噪音按钮

private struct WhiteNoiseButton: View {
    let type: WhiteNoiseType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color(.tertiarySystemGroupedBackground))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: type.icon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? .blue : .secondary)
                }
                
                Text(type.displayName)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .blue : .primary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Apple Music 选择器

struct AppleMusicPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var playlists: [Playlist] = []
    @State private var isLoading = true
    @State private var musicManager = FocusMusicManager.shared
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if playlists.isEmpty {
                    ContentUnavailableView(
                        "没有找到播放列表",
                        systemImage: "music.note.list",
                        description: Text("请先在 Apple Music 中创建播放列表")
                    )
                } else {
                    List(playlists, id: \.id) { playlist in
                        Button {
                            selectPlaylist(playlist)
                        } label: {
                            HStack {
                                if let artwork = playlist.artwork {
                                    ArtworkImage(artwork, width: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                } else {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(.tertiarySystemGroupedBackground))
                                        .frame(width: 50, height: 50)
                                        .overlay {
                                            Image(systemName: "music.note.list")
                                                .foregroundStyle(.secondary)
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(playlist.name)
                                        .foregroundStyle(.primary)
                                    if let description = playlist.shortDescription {
                                        Text(description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(L10n.appleMusicSelectPlaylist)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        dismiss()
                    }
                }
            }
            .task {
                await loadPlaylists()
            }
        }
    }
    
    private func loadPlaylists() async {
        do {
            var request = MusicLibraryRequest<Playlist>()
            request.limit = 50
            let response = try await request.response()
            await MainActor.run {
                playlists = Array(response.items)
                isLoading = false
            }
        } catch {
            print("Failed to load playlists: \(error)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func selectPlaylist(_ playlist: Playlist) {
        Task {
            await musicManager.setQueue([playlist])
            await musicManager.playAppleMusic()
            await MainActor.run {
                dismiss()
            }
        }
    }
}

#Preview {
    FocusMusicSheet()
}
