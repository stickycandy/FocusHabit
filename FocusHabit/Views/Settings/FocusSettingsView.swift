//
//  FocusSettingsView.swift
//  FocusHabit
//
//  专注计时器设置视图
//

import SwiftUI

/// 专注设置视图
struct FocusSettingsView: View {
    @Bindable private var settings = AppSettings.shared
    
    /// 专注时长选项（分钟）
    private let focusDurationOptions = [15, 20, 25, 30, 45, 60]
    /// 休息时长选项（分钟）
    private let breakDurationOptions = [3, 5, 10, 15, 20]
    /// 长休息前的专注次数选项
    private let sessionsOptions = [2, 3, 4, 5, 6]
    
    var body: some View {
        Form {
            // 时长设置
            Section {
                // 专注时长
                Picker("专注时长", selection: $settings.focusDuration) {
                    ForEach(focusDurationOptions, id: \.self) { minutes in
                        Text("\(minutes) 分钟").tag(minutes)
                    }
                }
                
                // 短休息时长
                Picker("短休息时长", selection: $settings.shortBreakDuration) {
                    ForEach(breakDurationOptions, id: \.self) { minutes in
                        Text("\(minutes) 分钟").tag(minutes)
                    }
                }
                
                // 长休息时长
                Picker("长休息时长", selection: $settings.longBreakDuration) {
                    ForEach(breakDurationOptions, id: \.self) { minutes in
                        Text("\(minutes) 分钟").tag(minutes)
                    }
                }
            } header: {
                Text("时长设置")
            } footer: {
                Text("番茄工作法建议：专注 25 分钟，短休息 5 分钟")
            }
            
            // 循环设置
            Section {
                Picker("长休息间隔", selection: $settings.sessionsUntilLongBreak) {
                    ForEach(sessionsOptions, id: \.self) { count in
                        Text("\(count) 个番茄钟").tag(count)
                    }
                }
            } header: {
                Text("循环设置")
            } footer: {
                Text("完成设定次数的专注后，进入长休息")
            }
            
            // 自动化设置
            Section {
                Toggle(isOn: $settings.autoStartBreaks) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("自动开始休息")
                        Text("专注结束后自动进入休息")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Toggle(isOn: $settings.autoStartFocus) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("自动开始专注")
                        Text("休息结束后自动进入专注")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("自动化")
            }
            
            // 当前配置预览
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.orange)
                        Text("一个完整周期")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    // 周期可视化
                    HStack(spacing: 4) {
                        ForEach(0..<settings.sessionsUntilLongBreak, id: \.self) { index in
                            // 专注
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.red.opacity(0.8))
                                .frame(width: 40, height: 24)
                                .overlay {
                                    Text("\(settings.focusDuration)")
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                }
                            
                            // 休息
                            if index < settings.sessionsUntilLongBreak - 1 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.green.opacity(0.8))
                                    .frame(width: 24, height: 24)
                                    .overlay {
                                        Text("\(settings.shortBreakDuration)")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                    }
                            } else {
                                // 最后一个是长休息
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.blue.opacity(0.8))
                                    .frame(width: 32, height: 24)
                                    .overlay {
                                        Text("\(settings.longBreakDuration)")
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
                    
                    // 总时长
                    let totalMinutes = settings.focusDuration * settings.sessionsUntilLongBreak +
                                       settings.shortBreakDuration * (settings.sessionsUntilLongBreak - 1) +
                                       settings.longBreakDuration
                    Text("总时长约 \(totalMinutes) 分钟（\(String(format: "%.1f", Double(totalMinutes) / 60)) 小时）")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("配置预览")
            }
        }
        .navigationTitle("专注设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FocusSettingsView()
    }
}