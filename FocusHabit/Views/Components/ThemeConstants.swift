//
//  ThemeConstants.swift
//  FocusHabit
//
//  主题常量：颜色和图标预设
//

import SwiftUI

/// 主题色枚举（根据 PRD 定义的 6 种主题色）
enum ThemeColor: String, CaseIterable, Identifiable {
    case oceanBlue = "#007AFF"      // 海洋蓝
    case vitalOrange = "#FF9500"    // 活力橙
    case freshGreen = "#34C759"     // 清新绿
    case romanticPurple = "#AF52DE" // 浪漫紫
    case warmRed = "#FF3B30"        // 温暖红
    case elegantBlack = "#1C1C1E"   // 优雅黑
    
    var id: String { rawValue }
    
    /// 颜色名称（用于显示，本地化）
    var displayName: String {
        switch self {
        case .oceanBlue: return L10n.colorOceanBlue
        case .vitalOrange: return L10n.colorVitalOrange
        case .freshGreen: return L10n.colorFreshGreen
        case .romanticPurple: return L10n.colorRomanticPurple
        case .warmRed: return L10n.colorWarmRed
        case .elegantBlack: return L10n.colorElegantBlack
        }
    }
    
    /// SwiftUI 颜色
    var color: Color {
        Color(hex: rawValue)
    }
}

/// 预设图标（SF Symbols）
enum PresetIcons {
    static let all: [String] = [
        // 基础
        "star.fill", "heart.fill", "checkmark.circle.fill",
        // 学习
        "book.fill", "pencil", "graduationcap.fill",
        // 健康
        "dumbbell.fill", "figure.walk", "figure.run",
        // 饮食
        "cup.and.saucer.fill", "fork.knife", "drop.fill",
        // 生活
        "moon.fill", "sun.max.fill", "bed.double.fill",
        // 自然
        "leaf.fill", "flame.fill", "cloud.fill",
        // 娱乐
        "music.note", "paintbrush.fill", "gamecontroller.fill",
        // 其他
        "keyboard", "brain.head.profile", "pills.fill"
    ]
}