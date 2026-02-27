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
    }
    
    // MARK: - 通知设置
    
    /// 是否启用通知
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }
    
    /// 每日提醒时间（存储为时间戳）
    var dailyReminderTime: Date {
        get {
            let timestamp = defaults.double(forKey: Keys.dailyReminderTime)
            if timestamp == 0 {
                // 默认早上 9:00
                var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                components.hour = 9
                components.minute = 0
                return Calendar.current.date(from: components) ?? Date()
            }
            return Date(timeIntervalSince1970: timestamp)
        }
        set { defaults.set(newValue.timeIntervalSince1970, forKey: Keys.dailyReminderTime) }
    }
    
    // MARK: - 专注设置
    
    /// 专注时长（分钟），默认 25
    var focusDuration: Int {
        get {
            let value = defaults.integer(forKey: Keys.focusDuration)
            return value == 0 ? 25 : value
        }
        set { defaults.set(newValue, forKey: Keys.focusDuration) }
    }
    
    /// 短休息时长（分钟），默认 5
    var shortBreakDuration: Int {
        get {
            let value = defaults.integer(forKey: Keys.shortBreakDuration)
            return value == 0 ? 5 : value
        }
        set { defaults.set(newValue, forKey: Keys.shortBreakDuration) }
    }
    
    /// 长休息时长（分钟），默认 15
    var longBreakDuration: Int {
        get {
            let value = defaults.integer(forKey: Keys.longBreakDuration)
            return value == 0 ? 15 : value
        }
        set { defaults.set(newValue, forKey: Keys.longBreakDuration) }
    }
    
    /// 进入长休息前的专注次数，默认 4
    var sessionsUntilLongBreak: Int {
        get {
            let value = defaults.integer(forKey: Keys.sessionsUntilLongBreak)
            return value == 0 ? 4 : value
        }
        set { defaults.set(newValue, forKey: Keys.sessionsUntilLongBreak) }
    }
    
    /// 自动开始休息
    var autoStartBreaks: Bool {
        get { defaults.bool(forKey: Keys.autoStartBreaks) }
        set { defaults.set(newValue, forKey: Keys.autoStartBreaks) }
    }
    
    /// 休息后自动开始专注
    var autoStartFocus: Bool {
        get { defaults.bool(forKey: Keys.autoStartFocus) }
        set { defaults.set(newValue, forKey: Keys.autoStartFocus) }
    }
    
    // MARK: - 声音与振动
    
    /// 是否启用提示音
    var soundEnabled: Bool {
        get {
            // 默认开启
            if defaults.object(forKey: Keys.soundEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.soundEnabled)
        }
        set { defaults.set(newValue, forKey: Keys.soundEnabled) }
    }
    
    /// 是否启用振动
    var vibrationEnabled: Bool {
        get {
            // 默认开启
            if defaults.object(forKey: Keys.vibrationEnabled) == nil {
                return true
            }
            return defaults.bool(forKey: Keys.vibrationEnabled)
        }
        set { defaults.set(newValue, forKey: Keys.vibrationEnabled) }
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
    
    private init() {}
}