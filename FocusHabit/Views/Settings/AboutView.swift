//
//  AboutView.swift
//  FocusHabit
//
//  关于页面
//

import SwiftUI

/// 关于页面
struct AboutView: View {
    
    /// 应用版本号
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// 构建版本号
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        Form {
            // 应用信息
            Section {
                VStack(spacing: 16) {
                    // App 图标
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                    }
                    
                    // 应用名称
                    Text("FocusHabit")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // 版本信息
                    Text(L10n.versionFormat(appVersion, buildNumber))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // 描述
                    Text(L10n.appDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            
            // 功能特性
            Section {
                FeatureRow(icon: "checkmark.circle.fill", color: .green, title: L10n.featureHabitTracking, description: L10n.featureHabitTrackingDesc)
                FeatureRow(icon: "timer", color: .orange, title: L10n.featurePomodoro, description: L10n.featurePomodoroDesc)
                FeatureRow(icon: "chart.bar.fill", color: .blue, title: L10n.featureStatistics, description: L10n.featureStatisticsDesc)
                FeatureRow(icon: "bell.fill", color: .purple, title: L10n.featureReminder, description: L10n.featureReminderDesc)
            } header: {
                Text(L10n.features)
            }
            
            // 联系方式
            Section {
                Link(destination: URL(string: "https://github.com/stickycandy/FocusHabit")!) {
                    Label("GitHub", systemImage: "link")
                }
                
                Link(destination: URL(string: "mailto:liziqiangrui@hotmail.com")!) {
                    Label(L10n.feedback, systemImage: "envelope")
                }
            } header: {
                Text(L10n.contactUs)
            }
            
            // 版权信息
            Section {
                Text(L10n.copyright)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle(L10n.about)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 功能行组件

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}