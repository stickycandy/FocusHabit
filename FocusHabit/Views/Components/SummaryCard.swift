//
//  SummaryCard.swift
//  FocusHabit
//
//  数据摘要卡片组件
//

import SwiftUI

/// 摘要卡片组件
/// 用于展示单个统计指标
struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

/// 摘要卡片网格
/// 展示 4 个核心指标
struct SummaryCardsGrid: View {
    let totalCheckIns: Int
    let todayProgress: String
    let longestStreak: Int
    let weeklyRate: Int
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            SummaryCard(
                title: "总打卡",
                value: "\(totalCheckIns)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            SummaryCard(
                title: "今日进度",
                value: todayProgress,
                icon: "sun.max.fill",
                color: .orange
            )
            
            SummaryCard(
                title: "最长连续",
                value: "\(longestStreak) 天",
                icon: "flame.fill",
                color: .red
            )
            
            SummaryCard(
                title: "本周完成率",
                value: "\(weeklyRate)%",
                icon: "chart.line.uptrend.xyaxis",
                color: .blue
            )
        }
    }
}

#Preview {
    SummaryCardsGrid(
        totalCheckIns: 128,
        todayProgress: "3/5",
        longestStreak: 14,
        weeklyRate: 85
    )
    .padding()
}