//
//  StatisticsHelper.swift
//  FocusHabit
//
//  统计数据计算辅助方法
//

import Foundation

/// 统计数据计算辅助
enum StatisticsHelper {
    
    /// 计算最长连续打卡天数
    static func longestStreak(from logs: [HabitLog]) -> Int {
        guard !logs.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        
        // 提取所有打卡日期（去重，只保留日期部分）
        let dates = Set(logs.map { calendar.startOfDay(for: $0.completedAt) })
        let sortedDates = dates.sorted()
        
        guard !sortedDates.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedDates.count {
            let previousDate = sortedDates[i - 1]
            let currentDate = sortedDates[i]
            
            // 检查是否是连续的一天
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(nextDay, inSameDayAs: currentDate) {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    /// 计算本周完成率
    static func weeklyCompletionRate(habits: [Habit], logs: [HabitLog]) -> Int {
        guard !habits.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let today = Date()
        
        // 获取本周开始日期（周一）
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0
        }
        
        // 计算本周已过天数
        let daysPassed = calendar.dateComponents([.day], from: weekStart, to: today).day ?? 0 + 1
        let actualDays = min(max(daysPassed, 1), 7)
        
        // 应完成次数 = 习惯数 × 已过天数
        let expectedCount = habits.count * actualDays
        
        // 实际完成次数（本周内的打卡）
        let weekLogs = logs.filter { log in
            log.completedAt >= weekStart && log.completedAt <= today
        }
        
        // 按天去重计算（每个习惯每天只算一次）
        var uniqueCompletions = Set<String>()
        for log in weekLogs {
            if let habit = log.habit {
                let dayKey = "\(habit.id)-\(calendar.startOfDay(for: log.completedAt))"
                uniqueCompletions.insert(dayKey)
            }
        }
        
        let actualCount = uniqueCompletions.count
        
        guard expectedCount > 0 else { return 0 }
        return Int((Double(actualCount) / Double(expectedCount)) * 100)
    }
    
    /// 获取今日完成的习惯数
    static func todayCompletedCount(habits: [Habit]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return habits.filter { habit in
            habit.logs.contains { log in
                calendar.isDate(log.completedAt, inSameDayAs: today)
            }
        }.count
    }
    
    /// 获取近 N 天每天的打卡次数
    static func dailyCheckIns(from logs: [HabitLog], days: Int) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var result: [(date: Date, count: Int)] = []
        
        for dayOffset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            let count = logs.filter { log in
                calendar.isDate(log.completedAt, inSameDayAs: date)
            }.count
            
            result.append((date: date, count: count))
        }
        
        return result
    }
    
    /// 获取指定月份每天的打卡次数
    static func monthlyCheckIns(from logs: [HabitLog], for month: Date) -> [Int: Int] {
        let calendar = Calendar.current
        
        // 获取月份的范围
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return [:]
        }
        
        var result: [Int: Int] = [:]
        
        for log in logs {
            if log.completedAt >= monthInterval.start && log.completedAt < monthInterval.end {
                let day = calendar.component(.day, from: log.completedAt)
                result[day, default: 0] += 1
            }
        }
        
        return result
    }
}