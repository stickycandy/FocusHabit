//
//  FocusSession.swift
//  FocusHabit
//
//  专注记录数据模型
//  根据 PRD 定义：id, startTime, endTime, duration, status, relatedHabitId, rating
//

import Foundation
import SwiftData

/// 专注状态枚举
/// 根据 Design 决策，使用 String 原始值便于存储和调试
enum FocusStatus: String, Codable {
    /// 已完成
    case completed
    /// 已取消
    case cancelled
    /// 被中断
    case interrupted
}

/// 专注记录模型
/// 记录番茄钟专注会话
@Model
final class FocusSession {
    /// 唯一标识符
    var id: UUID
    
    /// 开始时间
    var startTime: Date
    
    /// 结束时间
    var endTime: Date?
    
    /// 专注时长（秒）
    var duration: Int
    
    /// 专注状态
    var status: FocusStatus
    
    /// 用户评分（1-5 星）
    var rating: Int?
    
    /// 关联的习惯（可选）
    var relatedHabit: Habit?
    
    /// 初始化方法 - 开始新的专注
    init(duration: Int = 25 * 60, relatedHabit: Habit? = nil) {
        self.id = UUID()
        self.startTime = Date()
        self.duration = duration
        self.status = .completed
        self.relatedHabit = relatedHabit
    }
    
    /// 完成专注
    func complete(rating: Int? = nil) {
        self.endTime = Date()
        self.status = .completed
        self.rating = rating
    }
    
    /// 取消专注
    func cancel() {
        self.endTime = Date()
        self.status = .cancelled
    }
    
    /// 中断专注
    func interrupt() {
        self.endTime = Date()
        self.status = .interrupted
    }
}