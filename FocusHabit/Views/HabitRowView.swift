//
//  HabitRowView.swift
//  FocusHabit
//
//  习惯列表行视图
//

import SwiftUI
import SwiftData

/// 习惯列表行视图
/// 显示单个习惯的信息，支持打卡操作
struct HabitRowView: View {
    @Environment(\.modelContext) private var modelContext
    let habit: Habit
    let onCheckIn: () -> Void
    
    /// 今日是否已完成
    private var isCompletedToday: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return habit.logs.contains { log in
            calendar.isDate(log.completedAt, inSameDayAs: today)
        }
    }
    
    /// 今日完成次数
    private var todayCompletionCount: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return habit.logs.filter { log in
            calendar.isDate(log.completedAt, inSameDayAs: today)
        }.count
    }
    
    /// 今日完成状态文本
    private var completionStatusText: String {
        let manager = LanguageManager.shared
        if isCompletedToday {
            return manager.localizedString("today_completed")
        } else {
            return manager.localizedString("today_not_completed")
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // 图标
            Image(systemName: habit.icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(Color(hex: habit.color))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // 习惯信息
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.headline)
                
                // 今日进度
                if habit.targetCount > 1 {
                    Text(L10n.completionProgress(todayCompletionCount, habit.targetCount))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(completionStatusText)
                        .font(.caption)
                        .foregroundStyle(isCompletedToday ? Color(hex: habit.color) : .secondary)
                }
            }
            
            Spacer()
            
            // 打卡按钮
            Button(action: {
                checkIn()
            }) {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 32))
                    .foregroundStyle(isCompletedToday ? Color(hex: habit.color) : .gray.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    /// 执行打卡
    private func checkIn() {
        // 创建打卡记录
        let log = HabitLog(habit: habit)
        modelContext.insert(log)
        
        // 触发震动反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // 回调
        onCheckIn()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    
    let habit = Habit(name: "阅读", icon: "book.fill", color: "#007AFF")
    container.mainContext.insert(habit)
    
    return List {
        HabitRowView(habit: habit, onCheckIn: {})
    }
    .modelContainer(container)
}