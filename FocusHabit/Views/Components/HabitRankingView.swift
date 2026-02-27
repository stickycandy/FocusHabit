//
//  HabitRankingView.swift
//  FocusHabit
//
//  习惯完成排行榜
//

import SwiftUI

/// 排行榜项数据
struct RankingItem: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
    let count: Int
    let streak: Int
}

/// 习惯排行榜视图
struct HabitRankingView: View {
    let habits: [Habit]
    
    /// 排行榜数据（按打卡次数排序）
    private var rankingItems: [RankingItem] {
        habits
            .map { habit in
                RankingItem(
                    id: habit.id,
                    name: habit.name,
                    icon: habit.icon,
                    color: Color(hex: habit.color) ?? .blue,
                    count: habit.logs.count,
                    streak: StatisticsHelper.longestStreak(from: habit.logs)
                )
            }
            .sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题
            Text(L10n.habitRanking)
                .font(.headline)
            
            if rankingItems.isEmpty {
                // 空状态
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text(L10n.noHabitData)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                // 排行列表
                VStack(spacing: 12) {
                    ForEach(Array(rankingItems.enumerated()), id: \.element.id) { index, item in
                        RankingRow(rank: index + 1, item: item)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

/// 排行榜行
private struct RankingRow: View {
    let rank: Int
    let item: RankingItem
    
    /// 排名图标/颜色
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .secondary
        }
    }
    
    private var rankIcon: String {
        switch rank {
        case 1: return "crown.fill"
        case 2, 3: return "medal.fill"
        default: return ""
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 排名
            ZStack {
                if rank <= 3 {
                    Image(systemName: rankIcon)
                        .font(.caption)
                        .foregroundStyle(rankColor)
                } else {
                    Text("\(rank)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 24)
            
            // 习惯图标
            ZStack {
                Circle()
                    .fill(item.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: item.icon)
                    .font(.caption)
                    .foregroundStyle(item.color)
            }
            
            // 习惯名称
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text(L10n.consecutiveDays(item.streak))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // 打卡次数
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(item.count)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text(L10n.times)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HabitRankingView(habits: [])
        .padding()
}