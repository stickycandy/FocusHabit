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
                    Text("版本 \(appVersion) (\(buildNumber))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // 描述
                    Text("专注习惯养成，用番茄钟提升效率")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
            
            // 功能特性
            Section {
                FeatureRow(icon: "checkmark.circle.fill", color: .green, title: "习惯追踪", description: "创建和管理每日习惯")
                FeatureRow(icon: "timer", color: .orange, title: "番茄钟", description: "25/5 分钟专注休息循环")
                FeatureRow(icon: "chart.bar.fill", color: .blue, title: "数据统计", description: "可视化习惯完成趋势")
                FeatureRow(icon: "bell.fill", color: .purple, title: "智能提醒", description: "定时推送打卡提醒")
            } header: {
                Text("功能特性")
            }
            
            // 联系方式
            Section {
                Link(destination: URL(string: "https://github.com/stickycandy/FocusHabit")!) {
                    Label("GitHub", systemImage: "link")
                }
                
                Link(destination: URL(string: "mailto:liziqiangrui@hotmail.com")!) {
                    Label("反馈建议", systemImage: "envelope")
                }
            } header: {
                Text("联系我们")
            }
            
            // 版权信息
            Section {
                Text("© 2026 FocusHabit. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("关于")
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