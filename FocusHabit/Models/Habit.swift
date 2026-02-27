//
//  Habit.swift
//  FocusHabit
//
//  习惯数据模型
//  根据 PRD 定义：id, name, icon, color, reminderTimes, frequency, targetCount, createdAt
//

import Foundation
import SwiftData

/// 习惯模型
/// 用于追踪用户创建的习惯
@Model
final class Habit {
    /// 唯一标识符
    var id: UUID
    
    /// 习惯名称
    var name: String
    
    /// 图标名称（SF Symbols）
    var icon: String
    
    /// 主题色（十六进制颜色值）
    var color: String
    
    /// 提醒时间列表（以 HH:mm 格式存储）
    var reminderTimes: [String]
    
    /// 重复频率（0-6 代表周日到周六，空数组代表每天）
    var frequency: [Int]
    
    /// 每日目标次数
    var targetCount: Int
    
    /// 创建时间
    var createdAt: Date
    
    /// 关联的打卡记录（1:N 关系，级联删除）
    @Relationship(deleteRule: .cascade, inverse: \HabitLog.habit)
    var logs: [HabitLog] = []
    
    /// 初始化方法
    init(
        name: String,
        icon: String = "star.fill",
        color: String = "#007AFF",
        reminderTimes: [String] = [],
        frequency: [Int] = [],
        targetCount: Int = 1
    ) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.color = color
        self.reminderTimes = reminderTimes
        self.frequency = frequency
        self.targetCount = targetCount
        self.createdAt = Date()
    }
}