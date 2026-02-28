//
//  LanguageManager.swift
//  FocusHabit
//
//  多语言管理器 - App 内语言切换支持
//

import Foundation
import SwiftUI

/// 支持的语言
enum AppLanguage: String, CaseIterable, Identifiable {
    case zhHans = "zh-Hans"  // 简体中文
    case zhHant = "zh-Hant"  // 繁体中文
    case en = "en"           // 英语
    
    var id: String { rawValue }
    
    /// 语言的本地名称（始终显示为该语言自己的名称）
    var localizedName: String {
        switch self {
        case .zhHans: return "简体中文"
        case .zhHant: return "繁體中文"
        case .en: return "English"
        }
    }
    
    /// 获取对应的 Locale
    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

/// 多语言管理器
@Observable
final class LanguageManager {
    
    // MARK: - Singleton
    static let shared = LanguageManager()
    
    // MARK: - Properties
    private let defaults = UserDefaults.standard
    private let languageKey = "app_language"
    
    /// 当前语言
    var currentLanguage: AppLanguage {
        didSet {
            defaults.set(currentLanguage.rawValue, forKey: languageKey)
            updateBundle()
        }
    }
    
    /// 当前使用的本地化 Bundle
    private(set) var bundle: Bundle = .main
    
    // MARK: - Initialization
    private init() {
        // 从 UserDefaults 读取保存的语言，如果没有则检测系统语言
        if let savedLanguage = defaults.string(forKey: languageKey),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            self.currentLanguage = Self.detectSystemLanguage()
        }
        updateBundle()
    }
    
    // MARK: - Methods
    
    /// 检测系统语言，返回最匹配的支持语言
    private static func detectSystemLanguage() -> AppLanguage {
        let preferredLanguages = Locale.preferredLanguages
        
        for lang in preferredLanguages {
            let lowercased = lang.lowercased()
            if lowercased.hasPrefix("zh-hans") || lowercased.hasPrefix("zh-cn") {
                return .zhHans
            } else if lowercased.hasPrefix("zh-hant") || lowercased.hasPrefix("zh-tw") || lowercased.hasPrefix("zh-hk") {
                return .zhHant
            } else if lowercased.hasPrefix("en") {
                return .en
            }
        }
        
        // 默认简体中文
        return .zhHans
    }
    
    /// 更新本地化 Bundle
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = .main
        }
    }
    
    /// 获取本地化字符串
    func localizedString(_ key: String, comment: String = "") -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    
    /// 获取带参数的本地化字符串
    func localizedString(_ key: String, _ args: CVarArg...) -> String {
        let format = localizedString(key)
        return String(format: format, arguments: args)
    }
    
    /// 获取日期格式化器
    func dateFormatter(format: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        if let format = format {
            formatter.dateFormat = format
        }
        return formatter
    }
    
    /// 格式化日期为本地化字符串（如 "2月27日 星期四" 或 "Feb 27, Thursday"）
    func formatDate(_ date: Date, style: DateFormatStyle = .dayWithWeekday) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        
        switch style {
        case .dayWithWeekday:
            switch currentLanguage {
            case .zhHans:
                formatter.dateFormat = "M月d日 EEEE"
            case .zhHant:
                formatter.dateFormat = "M月d日 EEEE"
            case .en:
                formatter.dateFormat = "MMM d, EEEE"
            }
        case .shortDate:
            formatter.dateStyle = .short
        case .fullDate:
            formatter.dateStyle = .full
        }
        
        return formatter.string(from: date)
    }
    
    enum DateFormatStyle {
        case dayWithWeekday  // "2月27日 星期四" / "Feb 27, Thursday"
        case shortDate       // 短日期
        case fullDate        // 完整日期
    }
}

// MARK: - 便捷访问

/// 本地化字符串的便捷访问
enum L10n {
    private static var manager: LanguageManager { .shared }
    
    // MARK: - 通用
    static var settings: String { manager.localizedString("settings") }
    static var cancel: String { manager.localizedString("cancel") }
    static var confirm: String { manager.localizedString("confirm") }
    static var delete: String { manager.localizedString("delete") }
    static var save: String { manager.localizedString("save") }
    static var done: String { manager.localizedString("done") }
    
    // MARK: - Tab Bar
    static var tabHabits: String { manager.localizedString("tab_habits") }
    static var tabStatistics: String { manager.localizedString("tab_statistics") }
    static var tabFocus: String { manager.localizedString("tab_focus") }
    static var tabSettings: String { manager.localizedString("tab_settings") }
    
    // MARK: - 问候语
    static var greetingMorning: String { manager.localizedString("greeting_morning") }
    static var greetingAfternoon: String { manager.localizedString("greeting_afternoon") }
    static var greetingEvening: String { manager.localizedString("greeting_evening") }
    
    // MARK: - 习惯列表
    static var emptyStateTitle: String { manager.localizedString("empty_state_title") }
    static var emptyStateSubtitle: String { manager.localizedString("empty_state_subtitle") }
    static var createHabit: String { manager.localizedString("create_habit") }
    static func habitCount(_ count: Int) -> String {
        manager.localizedString("habit_count", count)
    }
    static var checkInSuccess: String { manager.localizedString("check_in_success") }
    static func completionProgress(_ current: Int, _ target: Int) -> String {
        manager.localizedString("completion_progress", current, target)
    }
    
    // MARK: - 习惯表单
    static var deleteHabit: String { manager.localizedString("delete_habit") }
    static var deleteHabitConfirm: String { manager.localizedString("delete_habit_confirm") }
    static var habitName: String { manager.localizedString("habit_name") }
    static var habitNamePlaceholder: String { manager.localizedString("habit_name_placeholder") }
    static var targetCount: String { manager.localizedString("target_count") }
    static var basicInfo: String { manager.localizedString("basic_info") }
    static func dailyTarget(_ count: Int) -> String {
        manager.localizedString("daily_target", count)
    }
    static var editHabit: String { manager.localizedString("edit_habit") }
    static var newHabit: String { manager.localizedString("new_habit") }
    static var frequency: String { manager.localizedString("frequency") }
    static var frequencyDaily: String { manager.localizedString("frequency_daily") }
    static var frequencyWeekly: String { manager.localizedString("frequency_weekly") }
    static var frequencyCustom: String { manager.localizedString("frequency_custom") }
    
    // MARK: - 统计
    static var statisticsTitle: String { manager.localizedString("statistics_title") }
    static var totalCheckIns: String { manager.localizedString("total_check_ins") }
    static var todayProgress: String { manager.localizedString("today_progress") }
    static var longestStreak: String { manager.localizedString("longest_streak") }
    static var weeklyCompletion: String { manager.localizedString("weekly_completion") }
    static var checkInTrend: String { manager.localizedString("check_in_trend") }
    static var dailyCheckIns: String { manager.localizedString("daily_check_ins") }
    static func totalTimes(_ count: Int) -> String {
        manager.localizedString("total_times", count)
    }
    static var habitRanking: String { manager.localizedString("habit_ranking") }
    static var noHabitData: String { manager.localizedString("no_habit_data") }
    static func consecutiveDays(_ days: Int) -> String {
        manager.localizedString("consecutive_days", days)
    }
    static var times: String { manager.localizedString("times") }
    static var checkInCalendar: String { manager.localizedString("check_in_calendar") }
    static var less: String { manager.localizedString("less") }
    static var more: String { manager.localizedString("more") }
    static func monthlyTotal(_ count: Int) -> String {
        manager.localizedString("monthly_total", count)
    }
    static var chartRangeWeek: String { manager.localizedString("chart_range_week") }
    static var chartRangeMonth: String { manager.localizedString("chart_range_month") }
    static var chartTimeRange: String { manager.localizedString("chart_time_range") }
    static func streakDays(_ days: Int) -> String {
        manager.localizedString("streak_days", days)
    }
    
    // MARK: - 专注
    static var focusTitle: String { manager.localizedString("focus_title") }
    static var focusing: String { manager.localizedString("focusing") }
    static var startFocus: String { manager.localizedString("start_focus") }
    static var pauseFocus: String { manager.localizedString("pause_focus") }
    static var stopFocus: String { manager.localizedString("stop_focus") }
    static var continueFocus: String { manager.localizedString("continue_focus") }
    static var skipBreak: String { manager.localizedString("skip_break") }
    static var linkedHabit: String { manager.localizedString("linked_habit") }
    static var selectHabit: String { manager.localizedString("select_habit") }
    static var todayFocus: String { manager.localizedString("today_focus") }
    static var completedPomodoros: String { manager.localizedString("completed_pomodoros") }
    static var focusProgressNotSaved: String { manager.localizedString("focus_progress_not_saved") }
    static var shortBreak: String { manager.localizedString("short_break") }
    static var longBreak: String { manager.localizedString("long_break") }
    static var stopFocusAlert: String { manager.localizedString("stop_focus_alert") }
    static var continueFocusing: String { manager.localizedString("continue_focusing") }
    static var startBreak: String { manager.localizedString("start_break") }
    static func focusHoursMinutes(_ hours: Int, _ minutes: Int) -> String {
        manager.localizedString("focus_hours_minutes", hours, minutes)
    }
    static func focusMinutesOnly(_ minutes: Int) -> String {
        manager.localizedString("focus_minutes_only", minutes)
    }
    static func phaseCompletedTitle(_ phase: String) -> String {
        manager.localizedString("phase_completed_title", phase)
    }
    static var focusCompletedBody: String { manager.localizedString("focus_completed_body") }
    static var breakCompletedBody: String { manager.localizedString("break_completed_body") }
    
    // MARK: - 设置
    static var notificationSettings: String { manager.localizedString("notification_settings") }
    static var enabled: String { manager.localizedString("enabled") }
    static var disabled: String { manager.localizedString("disabled") }
    static var focusSettings: String { manager.localizedString("focus_settings") }
    static func minutesFormat(_ minutes: Int) -> String {
        manager.localizedString("minutes_format", minutes)
    }
    static var languageSettings: String { manager.localizedString("language_settings") }
    static var languageSettingsFooter: String { manager.localizedString("language_settings_footer") }
    static var dataManagement: String { manager.localizedString("data_management") }
    static var dataManagementSubtitle: String { manager.localizedString("data_management_subtitle") }
    static var about: String { manager.localizedString("about") }
    static var versionInfo: String { manager.localizedString("version_info") }
    
    // MARK: - 通知设置
    static var enableNotifications: String { manager.localizedString("enable_notifications") }
    static var notificationSwitch: String { manager.localizedString("notification_switch") }
    static var notificationSwitchDesc: String { manager.localizedString("notification_switch_desc") }
    static var permissionStatus: String { manager.localizedString("permission_status") }
    static var reminderSettings: String { manager.localizedString("reminder_settings") }
    static var sound: String { manager.localizedString("sound") }
    static var vibration: String { manager.localizedString("vibration") }
    static var notificationPermissionHint: String { manager.localizedString("notification_permission_hint") }
    
    // MARK: - 专注设置
    static var focusDuration: String { manager.localizedString("focus_duration") }
    static var shortBreakDuration: String { manager.localizedString("short_break_duration") }
    static var longBreakDuration: String { manager.localizedString("long_break_duration") }
    static var durationSettings: String { manager.localizedString("duration_settings") }
    static var pomodoroTip: String { manager.localizedString("pomodoro_tip") }
    static func pomodorosFormat(_ count: Int) -> String {
        manager.localizedString("pomodoros_format", count)
    }
    static var cycleSettings: String { manager.localizedString("cycle_settings") }
    static var cycleSettingsDesc: String { manager.localizedString("cycle_settings_desc") }
    static var autoStartBreak: String { manager.localizedString("auto_start_break") }
    static var autoStartBreakDesc: String { manager.localizedString("auto_start_break_desc") }
    static var autoStartFocus: String { manager.localizedString("auto_start_focus") }
    static var autoStartFocusDesc: String { manager.localizedString("auto_start_focus_desc") }
    static var automation: String { manager.localizedString("automation") }
    static var completeCycle: String { manager.localizedString("complete_cycle") }
    static var longBreakInterval: String { manager.localizedString("long_break_interval") }
    static func totalDuration(_ minutes: Int, _ hours: Double) -> String {
        manager.localizedString("total_duration", minutes, String(format: "%.1f", hours))
    }
    static var configPreview: String { manager.localizedString("config_preview") }
    
    // MARK: - 组件
    static var selectIcon: String { manager.localizedString("select_icon") }
    static var selectColor: String { manager.localizedString("select_color") }
    static var colorOceanBlue: String { manager.localizedString("color_ocean_blue") }
    static var colorVitalOrange: String { manager.localizedString("color_vital_orange") }
    static var colorFreshGreen: String { manager.localizedString("color_fresh_green") }
    static var colorRomanticPurple: String { manager.localizedString("color_romantic_purple") }
    static var colorWarmRed: String { manager.localizedString("color_warm_red") }
    static var colorElegantBlack: String { manager.localizedString("color_elegant_black") }
    static var chartAxisDate: String { manager.localizedString("chart_axis_date") }
    static var chartAxisCount: String { manager.localizedString("chart_axis_count") }
    
    // MARK: - 通用动作
    static var reset: String { manager.localizedString("reset") }
    static var clear: String { manager.localizedString("clear") }
    
    // MARK: - 数据管理
    static var dataOverview: String { manager.localizedString("data_overview") }
    static var habitCountLabel: String { manager.localizedString("habit_count_label") }
    static var checkInRecords: String { manager.localizedString("check_in_records") }
    static var focusRecords: String { manager.localizedString("focus_records") }
    static var exportData: String { manager.localizedString("export_data") }
    static var dataExport: String { manager.localizedString("data_export") }
    static var dataExportDesc: String { manager.localizedString("data_export_desc") }
    static var resetSettings: String { manager.localizedString("reset_settings") }
    static var clearAllData: String { manager.localizedString("clear_all_data") }
    static var dangerZone: String { manager.localizedString("danger_zone") }
    static var dangerZoneDesc: String { manager.localizedString("danger_zone_desc") }
    static var resetSettingsConfirm: String { manager.localizedString("reset_settings_confirm") }
    static var clearDataConfirm: String { manager.localizedString("clear_data_confirm") }
    
    // MARK: - 关于
    static var appDescription: String { manager.localizedString("app_description") }
    static var features: String { manager.localizedString("features") }
    static var featureHabitTracking: String { manager.localizedString("feature_habit_tracking") }
    static var featureHabitTrackingDesc: String { manager.localizedString("feature_habit_tracking_desc") }
    static var featurePomodoro: String { manager.localizedString("feature_pomodoro") }
    static var featurePomodoroDesc: String { manager.localizedString("feature_pomodoro_desc") }
    static var featureStatistics: String { manager.localizedString("feature_statistics") }
    static var featureStatisticsDesc: String { manager.localizedString("feature_statistics_desc") }
    static var featureReminder: String { manager.localizedString("feature_reminder") }
    static var featureReminderDesc: String { manager.localizedString("feature_reminder_desc") }
    static var contactUs: String { manager.localizedString("contact_us") }
    static var feedback: String { manager.localizedString("feedback") }
    static func versionFormat(_ version: String, _ build: String) -> String {
        manager.localizedString("version_format", version, build)
    }
    static var copyright: String { manager.localizedString("copyright") }
    
    // MARK: - 专注音乐
    static var focusMusic: String { manager.localizedString("focus_music") }
    static var focusMusicEnabled: String { manager.localizedString("focus_music_enabled") }
    static var whiteNoise: String { manager.localizedString("white_noise") }
    static var whiteNoiseForest: String { manager.localizedString("white_noise_forest") }
    static var whiteNoiseRain: String { manager.localizedString("white_noise_rain") }
    static var whiteNoiseOcean: String { manager.localizedString("white_noise_ocean") }
    static var whiteNoiseCrickets: String { manager.localizedString("white_noise_crickets") }
    static var appleMusic: String { manager.localizedString("apple_music") }
    static var appleMusicConnected: String { manager.localizedString("apple_music_connected") }
    static var appleMusicNotConnected: String { manager.localizedString("apple_music_not_connected") }
    static var appleMusicDenied: String { manager.localizedString("apple_music_denied") }
    static var appleMusicRestricted: String { manager.localizedString("apple_music_restricted") }
    static var appleMusicConnect: String { manager.localizedString("apple_music_connect") }
    static var appleMusicSelectPlaylist: String { manager.localizedString("apple_music_select_playlist") }
    static var nowPlaying: String { manager.localizedString("now_playing") }
    static var selectMusicSource: String { manager.localizedString("select_music_source") }
    static var musicVolume: String { manager.localizedString("music_volume") }
    static var stopMusicOnFocusEnd: String { manager.localizedString("stop_music_on_focus_end") }
    static var stopMusicOnFocusEndDesc: String { manager.localizedString("stop_music_on_focus_end_desc") }
}
