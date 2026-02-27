//
//  HabitListView.swift
//  FocusHabit
//
//  习惯列表主视图
//

import SwiftUI
import SwiftData

/// 习惯列表视图
/// App 的主界面，展示所有习惯
struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    
    @State private var showingAddSheet = false
    @State private var showCheckInAnimation = false
    
    private let languageManager = LanguageManager.shared
    
    /// 今日问候语
    private var todayGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return L10n.greetingMorning
        case 12..<18: return L10n.greetingAfternoon
        default: return L10n.greetingEvening
        }
    }
    
    /// 今日日期
    private var todayDate: String {
        languageManager.formatDate(Date(), style: .dayWithWeekday)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if habits.isEmpty {
                    // 空状态
                    emptyStateView
                } else {
                    // 习惯列表
                    habitListView
                }
            }
            .navigationTitle(todayGreeting)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                HabitFormView(habit: nil)
            }
        }
    }
    
    /// 空状态视图
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(L10n.emptyStateTitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(L10n.emptyStateSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddSheet = true }) {
                Label(L10n.createHabit, systemImage: "plus")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
    
    /// 习惯列表视图
    private var habitListView: some View {
        List {
            // 日期头部
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(todayDate)
                            .font(.headline)
                        Text(L10n.habitCount(habits.count))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            
            // 习惯列表
            Section {
                ForEach(habits) { habit in
                    NavigationLink {
                        HabitFormView(habit: habit)
                    } label: {
                        HabitRowView(habit: habit) {
                            // 打卡成功回调
                            withAnimation {
                                showCheckInAnimation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showCheckInAnimation = false
                            }
                        }
                    }
                }
                .onDelete(perform: deleteHabits)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if showCheckInAnimation {
                checkInSuccessOverlay
            }
        }
    }
    
    /// 打卡成功浮层
    private var checkInSuccessOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text(L10n.checkInSuccess)
                    .fontWeight(.medium)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding(.bottom, 100)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    /// 删除习惯
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habits[index])
            }
        }
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: [Habit.self, HabitLog.self], inMemory: true)
}