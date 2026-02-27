//
//  FocusSettingsView.swift
//  FocusHabit
//
//  专注计时器设置视图
//

import SwiftUI

/// 专注设置视图
struct FocusSettingsView: View {
    /// 专注时长选项（分钟）
    private let focusDurationOptions = [15, 20, 25, 30, 45, 60]
    /// 休息时长选项（分钟）
    private let breakDurationOptions = [3, 5, 10, 15, 20]
    /// 长休息前的专注次数选项
    private let sessionsOptions = [2, 3, 4, 5, 6]
    
    // 本地状态用于触发视图更新
    @State private var focusDuration: Int = AppSettings.shared.focusDuration
    @State private var shortBreakDuration: Int = AppSettings.shared.shortBreakDuration
    @State private var longBreakDuration: Int = AppSettings.shared.longBreakDuration
    @State private var sessionsUntilLongBreak: Int = AppSettings.shared.sessionsUntilLongBreak
    @State private var autoStartBreaks: Bool = AppSettings.shared.autoStartBreaks
    @State private var autoStartFocus: Bool = AppSettings.shared.autoStartFocus
    
    var body: some View {
        Form {
            // 时长设置
            Section {
                // 专注时长
                Picker(L10n.focusDuration, selection: $focusDuration) {
                    ForEach(focusDurationOptions, id: \.self) { minutes in
                        Text(L10n.minutesFormat(minutes)).tag(minutes)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: focusDuration) { _, newValue in
                    AppSettings.shared.focusDuration = newValue
                }
                
                // 短休息时长
                Picker(L10n.shortBreakDuration, selection: $shortBreakDuration) {
                    ForEach(breakDurationOptions, id: \.self) { minutes in
                        Text(L10n.minutesFormat(minutes)).tag(minutes)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: shortBreakDuration) { _, newValue in
                    AppSettings.shared.shortBreakDuration = newValue
                }
                
                // 长休息时长
                Picker(L10n.longBreakDuration, selection: $longBreakDuration) {
                    ForEach(breakDurationOptions, id: \.self) { minutes in
                        Text(L10n.minutesFormat(minutes)).tag(minutes)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: longBreakDuration) { _, newValue in
                    AppSettings.shared.longBreakDuration = newValue
                }
            } header: {
                Text(L10n.durationSettings)
            } footer: {
                Text(L10n.pomodoroTip)
            }
            
            // 循环设置
            Section {
                Picker(L10n.longBreakInterval, selection: $sessionsUntilLongBreak) {
                    ForEach(sessionsOptions, id: \.self) { count in
                        Text(L10n.pomodorosFormat(count)).tag(count)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: sessionsUntilLongBreak) { _, newValue in
                    AppSettings.shared.sessionsUntilLongBreak = newValue
                }
            } header: {
                Text(L10n.cycleSettings)
            } footer: {
                Text(L10n.cycleSettingsDesc)
            }
            
            // 自动化设置
            Section {
                Toggle(isOn: $autoStartBreaks) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.autoStartBreak)
                        Text(L10n.autoStartBreakDesc)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onChange(of: autoStartBreaks) { _, newValue in
                    AppSettings.shared.autoStartBreaks = newValue
                }
                
                Toggle(isOn: $autoStartFocus) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.autoStartFocus)
                        Text(L10n.autoStartFocusDesc)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onChange(of: autoStartFocus) { _, newValue in
                    AppSettings.shared.autoStartFocus = newValue
                }
            } header: {
                Text(L10n.automation)
            }
            
            // 当前配置预览
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.orange)
                        Text(L10n.completeCycle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    // 周期可视化
                    HStack(spacing: 4) {
                        ForEach(0..<sessionsUntilLongBreak, id: \.self) { index in
                            // 专注
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.red.opacity(0.8))
                                .frame(width: 40, height: 24)
                                .overlay {
                                    Text("\(focusDuration)")
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                }
                            
                            // 休息
                            if index < sessionsUntilLongBreak - 1 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.green.opacity(0.8))
                                    .frame(width: 24, height: 24)
                                    .overlay {
                                        Text("\(shortBreakDuration)")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                    }
                            } else {
                                // 最后一个是长休息
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.blue.opacity(0.8))
                                    .frame(width: 32, height: 24)
                                    .overlay {
                                        Text("\(longBreakDuration)")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
                    
                    // 总时长
                    let totalMinutes = focusDuration * sessionsUntilLongBreak +
                                       shortBreakDuration * (sessionsUntilLongBreak - 1) +
                                       longBreakDuration
                    Text(L10n.totalDuration(totalMinutes, Double(totalMinutes) / 60))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text(L10n.configPreview)
            }
        }
        .navigationTitle(L10n.focusSettings)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FocusSettingsView()
    }
}