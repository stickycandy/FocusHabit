//
//  AppSettings.swift
//  FocusHabit
//
//  应用设置管理（基于 UserDefaults）
//

import Foundation
import SwiftUI

/// 应用设置管理器
@Observable
final class AppSettings {
    
    // MARK: - Singleton
    static let shared = AppSettings()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let notificationsEnabled = "notificationsEnabled"
        static let dailyReminderTime = "dailyReminderTime"
        static let focusDuration = "focusDuration"
        static let shortBreakDuration = "shortBreakDuration"
        static let longBreakDuration = "longBreakDuration"
        static let sessionsUntilLongBreak = "sessionsUntilLongBreak"
        static let autoStartBreaks = "autoStartBreaks"
        static let autoStartFocus = "autoStartFocus"
        static let soundEnabled = "soundEnabled"
        static let vibrationEnabled = "vibrationEnabled"
        static let stopMusicOnFocusEnd = "stopMusicOnFocusEnd"
    }
    
    // MARK: - 存储属性（用于 @Observable 追踪）
    
    /// 是否启用通知
    var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled) }
    }
    
    /// 每日提醒时间
    var dailyReminderTime: Date {
        didSet { defaults.set(dailyReminderTime.timeIntervalSince1970, forKey: Keys.dailyReminderTime) }
    }
    
    /// 专注时长（分钟），默认 25
    var focusDuration: Int {
        didSet { defaults.set(focusDuration, forKey: Keys.focusDuration) }
    }
    
    /// 短休息时长（分钟），默认 5
    var shortBreakDuration: Int {
        didSet { defaults.set(shortBreakDuration, forKey: Keys.shortBreakDuration) }
    }
    
    /// 长休息时长（分钟），默认 15
    var longBreakDuration: Int {
        didSet { defaults.set(longBreakDuration, forKey: Keys.longBreakDuration) }
    }
    
    /// 进入长休息前的专注次数，默认 4
    var sessionsUntilLongBreak: Int {
        didSet { defaults.set(sessionsUntilLongBreak, forKey: Keys.sessionsUntilLongBreak) }
    }
    
    /// 自动开始休息
    var autoStartBreaks: Bool {
        didSet { defaults.set(autoStartBreaks, forKey: Keys.autoStartBreaks) }
    }
    
    /// 休息后自动开始专注
    var autoStartFocus: Bool {
        didSet { defaults.set(autoStartFocus, forKey: Keys.autoStartFocus) }
    }
    
    /// 是否启用提示音
    var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.soundEnabled) }
    }
    
    /// 是否启用振动
    var vibrationEnabled: Bool {
        didSet { defaults.set(vibrationEnabled, forKey: Keys.vibrationEnabled) }
    }
    
    /// 专注结束时停止音乐
    var stopMusicOnFocusEnd: Bool {
        didSet { defaults.set(stopMusicOnFocusEnd, forKey: Keys.stopMusicOnFocusEnd) }
    }
    
    // MARK: - 方法
    
    /// 重置所有设置为默认值
    func resetToDefaults() {
        notificationsEnabled = false
        focusDuration = 25
        shortBreakDuration = 5
        longBreakDuration = 15
        sessionsUntilLongBreak = 4
        autoStartBreaks = false
        autoStartFocus = false
        soundEnabled = true
        vibrationEnabled = true
        
        // 重置提醒时间为早上 9:00
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 9
        components.minute = 0
        if let defaultTime = Calendar.current.date(from: components) {
            dailyReminderTime = defaultTime
        }
    }
    
    private init() {
        // 从 UserDefaults 加载初始值
        self.notificationsEnabled = defaults.bool(forKey: Keys.notificationsEnabled)
        
        // 加载每日提醒时间
        let timestamp = defaults.double(forKey: Keys.dailyReminderTime)
        if timestamp == 0 {
            // 默认早上 9:00
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            self.dailyReminderTime = Calendar.current.date(from: components) ?? Date()
        } else {
            self.dailyReminderTime = Date(timeIntervalSince1970: timestamp)
        }
        
        // 加载专注设置
        let focusValue = defaults.integer(forKey: Keys.focusDuration)
        self.focusDuration = focusValue == 0 ? 25 : focusValue
        
        let shortBreakValue = defaults.integer(forKey: Keys.shortBreakDuration)
        self.shortBreakDuration = shortBreakValue == 0 ? 5 : shortBreakValue
        
        let longBreakValue = defaults.integer(forKey: Keys.longBreakDuration)
        self.longBreakDuration = longBreakValue == 0 ? 15 : longBreakValue
        
        let sessionsValue = defaults.integer(forKey: Keys.sessionsUntilLongBreak)
        self.sessionsUntilLongBreak = sessionsValue == 0 ? 4 : sessionsValue
        
        self.autoStartBreaks = defaults.bool(forKey: Keys.autoStartBreaks)
        self.autoStartFocus = defaults.bool(forKey: Keys.autoStartFocus)
        
        // 加载声音与振动设置（默认开启）
        self.soundEnabled = defaults.object(forKey: Keys.soundEnabled) == nil ? true : defaults.bool(forKey: Keys.soundEnabled)
        self.vibrationEnabled = defaults.object(forKey: Keys.vibrationEnabled) == nil ? true : defaults.bool(forKey: Keys.vibrationEnabled)
        
        // 加载音乐设置（默认专注结束时停止音乐）
        self.stopMusicOnFocusEnd = defaults.object(forKey: Keys.stopMusicOnFocusEnd) == nil ? true : defaults.bool(forKey: Keys.stopMusicOnFocusEnd)
    }
}
