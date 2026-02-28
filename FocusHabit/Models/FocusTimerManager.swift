//
//  FocusTimerManager.swift
//  FocusHabit
//
//  专注计时器状态管理器
//

import Foundation
import SwiftUI
import UserNotifications

/// 计时器阶段
enum TimerPhase: String {
    case focus = "focus"
    case shortBreak = "shortBreak"
    case longBreak = "longBreak"
    
    /// 本地化显示名称
    var displayName: String {
        switch self {
        case .focus: return L10n.focusing
        case .shortBreak: return L10n.shortBreak
        case .longBreak: return L10n.longBreak
        }
    }
    
    var color: Color {
        switch self {
        case .focus: return .red
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .focus: return "brain.head.profile"
        case .shortBreak: return "cup.and.saucer.fill"
        case .longBreak: return "figure.walk"
        }
    }
}

/// 计时器状态
enum TimerState {
    case idle       // 空闲
    case running    // 运行中
    case paused     // 暂停
    case completed  // 当前阶段完成
}

/// 专注计时器管理器
@Observable
final class FocusTimerManager {
    
    // MARK: - 状态属性
    
    /// 当前阶段
    var currentPhase: TimerPhase = .focus
    
    /// 当前状态
    var timerState: TimerState = .idle
    
    /// 剩余秒数
    var remainingSeconds: Int = 0
    
    /// 当前周期已完成的专注次数
    var completedFocusSessions: Int = 0
    
    /// 今日总专注时长（秒）
    var todayFocusSeconds: Int = 0
    
    /// 关联的习惯 ID
    var linkedHabitId: UUID?
    
    // MARK: - 私有属性
    
    private var timer: Timer?
    private var settings: AppSettings { AppSettings.shared }
    private var sessionStartTime: Date?
    
    // MARK: - 计算属性
    
    /// 当前阶段总时长（秒）
    var totalSeconds: Int {
        switch currentPhase {
        case .focus: return settings.focusDuration * 60
        case .shortBreak: return settings.shortBreakDuration * 60
        case .longBreak: return settings.longBreakDuration * 60
        }
    }
    
    /// 进度（0-1）
    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }
    
    /// 格式化的时间显示
    var timeDisplay: String {
        // 空闲状态下，直接显示当前阶段的总时长（实时响应设置变化）
        let displaySeconds = (timerState == .idle) ? totalSeconds : remainingSeconds
        let minutes = displaySeconds / 60
        let seconds = displaySeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// 今日专注时长格式化
    var todayFocusDisplay: String {
        let hours = todayFocusSeconds / 3600
        let minutes = (todayFocusSeconds % 3600) / 60
        let manager = LanguageManager.shared
        if hours > 0 {
            return manager.localizedString("focus_hours_minutes", hours, minutes)
        } else {
            return manager.localizedString("focus_minutes_only", minutes)
        }
    }
    
    // MARK: - 初始化
    
    init() {
        resetToFocusPhase()
        loadTodayFocusTime()
    }
    
    // MARK: - 公开方法
    
    /// 开始计时
    func start() {
        guard timerState != .running else { return }
        
        if timerState == .idle || timerState == .completed {
            remainingSeconds = totalSeconds
        }
        
        sessionStartTime = Date()
        timerState = .running
        startTimer()
        
        // 如果是专注阶段开始，恢复之前暂停的音乐
        if currentPhase == .focus {
            FocusMusicManager.shared.handleFocusStarted()
        }
    }
    
    /// 暂停计时
    func pause() {
        guard timerState == .running else { return }
        timerState = .paused
        stopTimer()
        
        // 累计已专注时间
        if currentPhase == .focus, let startTime = sessionStartTime {
            let elapsed = Int(Date().timeIntervalSince(startTime))
            todayFocusSeconds += elapsed
            saveTodayFocusTime()
        }
    }
    
    /// 恢复计时
    func resume() {
        guard timerState == .paused else { return }
        sessionStartTime = Date()
        timerState = .running
        startTimer()
    }
    
    /// 停止并重置
    func stop() {
        stopTimer()
        
        // 累计已专注时间
        if timerState == .running && currentPhase == .focus, let startTime = sessionStartTime {
            let elapsed = Int(Date().timeIntervalSince(startTime))
            todayFocusSeconds += elapsed
            saveTodayFocusTime()
        }
        
        resetToFocusPhase()
    }
    
    /// 跳过当前阶段
    func skip() {
        stopTimer()
        moveToNextPhase()
    }
    
    /// 关联习惯
    func linkHabit(_ habitId: UUID?) {
        linkedHabitId = habitId
    }
    
    // MARK: - 私有方法
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        guard remainingSeconds > 0 else { return }
        
        remainingSeconds -= 1
        
        if remainingSeconds == 0 {
            phaseCompleted()
        }
    }
    
    private func phaseCompleted() {
        stopTimer()
        timerState = .completed
        
        // 专注阶段完成
        if currentPhase == .focus {
            completedFocusSessions += 1
            
            // 累计专注时间
            if let startTime = sessionStartTime {
                let elapsed = Int(Date().timeIntervalSince(startTime))
                todayFocusSeconds += elapsed
                saveTodayFocusTime()
            }
            
            // 专注结束时处理音乐（停止或暂停）
            FocusMusicManager.shared.handleFocusEnded()
        } else {
            // 休息结束
            FocusMusicManager.shared.handleBreakEnded()
        }
        
        // 发送通知
        sendCompletionNotification()
        
        // 播放提示音/振动
        playCompletionFeedback()
        
        // 自动进入下一阶段
        if shouldAutoStart() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.moveToNextPhase()
                self?.start()
            }
        }
    }
    
    private func moveToNextPhase() {
        switch currentPhase {
        case .focus:
            // 检查是否应该进入长休息
            if completedFocusSessions >= settings.sessionsUntilLongBreak {
                currentPhase = .longBreak
                completedFocusSessions = 0
            } else {
                currentPhase = .shortBreak
            }
        case .shortBreak, .longBreak:
            currentPhase = .focus
        }
        
        remainingSeconds = totalSeconds
        timerState = .idle
    }
    
    private func resetToFocusPhase() {
        currentPhase = .focus
        timerState = .idle
        remainingSeconds = totalSeconds
        sessionStartTime = nil
    }
    
    private func shouldAutoStart() -> Bool {
        switch currentPhase {
        case .focus:
            return settings.autoStartBreaks
        case .shortBreak, .longBreak:
            return settings.autoStartFocus
        }
    }
    
    private func sendCompletionNotification() {
        guard settings.notificationsEnabled else { return }
        
        let manager = LanguageManager.shared
        let content = UNMutableNotificationContent()
        content.title = manager.localizedString("phase_completed_title", currentPhase.displayName)
        
        switch currentPhase {
        case .focus:
            content.body = manager.localizedString("focus_completed_body")
        case .shortBreak, .longBreak:
            content.body = manager.localizedString("break_completed_body")
        }
        
        if settings.soundEnabled {
            content.sound = .default
        }
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func playCompletionFeedback() {
        if settings.vibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    // MARK: - 持久化今日专注时间
    
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "focusTime_\(formatter.string(from: Date()))"
    }
    
    private func loadTodayFocusTime() {
        todayFocusSeconds = UserDefaults.standard.integer(forKey: todayKey)
    }
    
    private func saveTodayFocusTime() {
        UserDefaults.standard.set(todayFocusSeconds, forKey: todayKey)
    }
}