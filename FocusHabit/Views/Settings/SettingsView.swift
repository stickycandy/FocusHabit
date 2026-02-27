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
    @Bindable private var languageManager = LanguageManager.shared
    
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
                            title: L10n.notificationSettings,
                            subtitle: settings.notificationsEnabled ? L10n.enabled : L10n.disabled
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
                            title: L10n.focusSettings,
                            subtitle: L10n.minutesFormat(settings.focusDuration)
                        )
                    }
                }
                
                // 语言设置
                Section {
                    NavigationLink {
                        LanguageSettingsView()
                    } label: {
                        SettingsRow(
                            icon: "globe",
                            color: .purple,
                            title: L10n.languageSettings,
                            subtitle: languageManager.currentLanguage.localizedName
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
                            title: L10n.dataManagement,
                            subtitle: L10n.dataManagementSubtitle
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
                            title: L10n.about,
                            subtitle: L10n.versionInfo
                        )
                    }
                }
            }
            .navigationTitle(L10n.settings)
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