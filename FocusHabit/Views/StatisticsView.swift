//
//  StatisticsView.swift
//  FocusHabit
//
//  数据统计主页面
//

import SwiftUI
import SwiftData

/// 数据统计主页面
struct StatisticsView: View {
    @Query private var habits: [Habit]
    @Query private var logs: [HabitLog]
    
    /// 所有日志（扁平化）
    private var allLogs: [HabitLog] {
        habits.flatMap { $0.logs }
    }
    
    /// 统计数据
    private var totalCheckIns: Int {
        allLogs.count
    }
    
    private var todayProgress: String {
        let completed = StatisticsHelper.todayCompletedCount(habits: habits)
        let total = habits.count
        return "\(completed)/\(total)"
    }
    
    private var longestStreak: Int {
        StatisticsHelper.longestStreak(from: allLogs)
    }
    
    private var weeklyRate: Int {
        StatisticsHelper.weeklyCompletionRate(habits: habits, logs: allLogs)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 概览卡片
                    SummaryCardsGrid(
                        totalCheckIns: totalCheckIns,
                        todayProgress: todayProgress,
                        longestStreak: longestStreak,
                        weeklyRate: weeklyRate
                    )
                    
                    // 打卡趋势图表
                    CompletionChart(logs: allLogs)
                    
                    // 日历热力图
                    CalendarHeatmap(logs: allLogs)
                    
                    // 习惯排行榜
                    HabitRankingView(habits: habits)
                }
                .padding()
            }
            .navigationTitle("数据统计")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: [Habit.self, HabitLog.self, FocusSession.self], inMemory: true)
}