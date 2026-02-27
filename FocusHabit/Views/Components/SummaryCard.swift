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
                title: L10n.totalCheckIns,
                value: "\(totalCheckIns)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            SummaryCard(
                title: L10n.todayProgress,
                value: todayProgress,
                icon: "sun.max.fill",
                color: .orange
            )
            
            SummaryCard(
                title: L10n.longestStreak,
                value: L10n.streakDays(longestStreak),
                icon: "flame.fill",
                color: .red
            )
            
            SummaryCard(
                title: L10n.weeklyCompletion,
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