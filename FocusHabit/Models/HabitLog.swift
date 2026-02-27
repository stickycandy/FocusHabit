//
//  HabitLog.swift
//  FocusHabit
//
//  打卡记录数据模型
//  根据 PRD 定义：id, habitId, completedAt, note
//

import Foundation
import SwiftData

/// 打卡记录模型
/// 记录每次习惯完成情况
@Model
final class HabitLog {
    /// 唯一标识符
    var id: UUID
    
    /// 完成时间
    var completedAt: Date
    
    /// 备注（可选）
    var note: String?
    
    /// 关联的习惯（必须关联一个有效的 Habit）
    var habit: Habit?
    
    /// 初始化方法
    init(habit: Habit, note: String? = nil) {
        self.id = UUID()
        self.completedAt = Date()
        self.note = note
        self.habit = habit
    }
}