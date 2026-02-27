//
//  SettingsView.swift
//  FocusHabit
//
//  设置主页面
//

import SwiftUI

/// 设置主页面
struct SettingsView: View {
    @Bindable private var settings = AppSettings.shared
    
    var body: some View {
        NavigationStack {
            Form {
                // 通知设置
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "bell.fill",
                            color: .red,
                            title: "通知设置",
                            subtitle: settings.notificationsEnabled ? "已开启" : "已关闭"
                        )
                    }
                }
                
                // 专注设置
                Section {
                    NavigationLink {
                        FocusSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "timer",
                            color: .orange,
                            title: "专注设置",
                            subtitle: "\(settings.focusDuration) 分钟"
                        )
                    }
                }
                
                // 数据管理
                Section {
                    NavigationLink {
                        DataManagementView()
                    } label: {
                        SettingsRow(
                            icon: "externaldrive.fill",
                            color: .blue,
                            title: "数据管理",
                            subtitle: "导出、备份、重置"
                        )
                    }
                }
                
                // 关于
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        SettingsRow(
                            icon: "info.circle.fill",
                            color: .gray,
                            title: "关于",
                            subtitle: "版本信息"
                        )
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

// MARK: - 设置行组件

private struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            // 图标
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            
            // 文字
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SettingsView()
}