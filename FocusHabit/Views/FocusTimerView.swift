//
//  FocusTimerView.swift
//  FocusHabit
//
//  专注计时器主页面
//

import SwiftUI
import SwiftData

/// 专注计时器主页面
struct FocusTimerView: View {
    @Query private var habits: [Habit]
    @State private var timerManager = FocusTimerManager()
    @State private var showingHabitPicker = false
    @State private var showingStopAlert = false
    
    /// 关联的习惯
    private var linkedHabit: Habit? {
        guard let habitId = timerManager.linkedHabitId else { return nil }
        return habits.first { $0.id == habitId }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 阶段指示器
                PhaseIndicator(
                    currentPhase: timerManager.currentPhase,
                    completedSessions: timerManager.completedFocusSessions,
                    totalSessions: AppSettings.shared.sessionsUntilLongBreak
                )
                .padding(.top, 20)
                
                Spacer()
                
                // 计时器圆环
                timerCircle
                    .padding(.horizontal, 40)
                
                Spacer()
                
                // 关联习惯
                linkedHabitSection
                    .padding(.horizontal)
                
                // 控制按钮
                controlButtons
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                // 今日统计
                todayStats
            }
            .navigationTitle(L10n.focusTitle)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingHabitPicker) {
                habitPickerSheet
            }
            .alert(L10n.stopFocusAlert, isPresented: $showingStopAlert) {
                Button(L10n.continueFocusing, role: .cancel) {}
                Button(L10n.stopFocus, role: .destructive) {
                    timerManager.stop()
                }
            } message: {
                Text(L10n.focusProgressNotSaved)
            }
        }
    }
    
    // MARK: - 计时器圆环
    
    private var timerCircle: some View {
        CircularProgressWithContent(
            progress: timerManager.progress,
            color: timerManager.currentPhase.color,
            lineWidth: 16
        ) {
            VStack(spacing: 8) {
                // 阶段图标
                Image(systemName: timerManager.currentPhase.icon)
                    .font(.title)
                    .foregroundStyle(timerManager.currentPhase.color)
                
                // 时间显示
                Text(timerManager.timeDisplay)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                
                // 阶段名称
                Text(timerManager.currentPhase.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 280, height: 280)
    }
    
    // MARK: - 关联习惯区域
    
    private var linkedHabitSection: some View {
        Button {
            showingHabitPicker = true
        } label: {
            HStack {
                if let habit = linkedHabit {
                    // 已关联习惯
                    ZStack {
                        Circle()
                            .fill((Color(hex: habit.color) ?? .gray).opacity(0.2))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: habit.icon)
                            .font(.caption)
                            .foregroundStyle(Color(hex: habit.color) ?? .gray)
                    }
                    
                    Text(habit.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button {
                        timerManager.linkHabit(nil)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    // 未关联
                    Image(systemName: "link")
                        .foregroundStyle(.secondary)
                    
                    Text(L10n.linkedHabit)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.bottom, 20)
    }
    
    // MARK: - 控制按钮
    
    private var controlButtons: some View {
        HStack(spacing: 24) {
            switch timerManager.timerState {
            case .idle:
                // 开始按钮
                primaryButton(
                    title: L10n.startFocus,
                    icon: "play.fill",
                    color: timerManager.currentPhase.color
                ) {
                    timerManager.start()
                }
                
            case .running:
                // 暂停按钮
                secondaryButton(title: L10n.pauseFocus, icon: "pause.fill") {
                    timerManager.pause()
                }
                
                // 停止按钮
                secondaryButton(title: L10n.stopFocus, icon: "stop.fill") {
                    showingStopAlert = true
                }
                
            case .paused:
                // 继续按钮
                primaryButton(
                    title: L10n.continueFocus,
                    icon: "play.fill",
                    color: timerManager.currentPhase.color
                ) {
                    timerManager.resume()
                }
                
                // 停止按钮
                secondaryButton(title: L10n.stopFocus, icon: "stop.fill") {
                    timerManager.stop()
                }
                
            case .completed:
                // 下一阶段按钮
                primaryButton(
                    title: nextPhaseTitle,
                    icon: "arrow.right",
                    color: timerManager.currentPhase.color
                ) {
                    timerManager.skip()
                    timerManager.start()
                }
                
                // 跳过按钮
                secondaryButton(title: L10n.skipBreak, icon: "forward.fill") {
                    timerManager.skip()
                }
            }
        }
    }
    
    private var nextPhaseTitle: String {
        switch timerManager.currentPhase {
        case .focus:
            return L10n.startBreak
        case .shortBreak, .longBreak:
            return L10n.startFocus
        }
    }
    
    private func primaryButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func secondaryButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - 今日统计
    
    private var todayStats: some View {
        HStack {
            StatItem(
                icon: "clock.fill",
                title: L10n.todayFocus,
                value: timerManager.todayFocusDisplay
            )
            
            Divider()
                .frame(height: 40)
            
            StatItem(
                icon: "flame.fill",
                title: L10n.completedPomodoros,
                value: "\(timerManager.completedFocusSessions)"
            )
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - 习惯选择器
    
    private var habitPickerSheet: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    Button {
                        timerManager.linkHabit(habit.id)
                        showingHabitPicker = false
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill((Color(hex: habit.color) ?? .gray).opacity(0.2))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: habit.icon)
                                    .foregroundStyle(Color(hex: habit.color) ?? .gray)
                            }
                            
                            Text(habit.name)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if timerManager.linkedHabitId == habit.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle(L10n.selectHabit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.cancel) {
                        showingHabitPicker = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - 阶段指示器

private struct PhaseIndicator: View {
    let currentPhase: TimerPhase
    let completedSessions: Int
    let totalSessions: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSessions, id: \.self) { index in
                Circle()
                    .fill(index < completedSessions ? currentPhase.color : Color(.systemGray4))
                    .frame(width: 10, height: 10)
            }
        }
    }
}

// MARK: - 统计项

private struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.orange)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FocusTimerView()
        .modelContainer(for: [Habit.self, HabitLog.self, FocusSession.self], inMemory: true)
}