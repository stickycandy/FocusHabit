//
//  CompletionChart.swift
//  FocusHabit
//
//  完成率趋势图表（使用 Swift Charts）
//

import SwiftUI
import Charts

/// 图表数据点
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    
    var dayLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"  // 周几
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}

/// 时间范围枚举
enum ChartTimeRange: String, CaseIterable {
    case week = "7天"
    case month = "30天"
    
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        }
    }
}

/// 完成率趋势图表
struct CompletionChart: View {
    let logs: [HabitLog]
    @State private var selectedRange: ChartTimeRange = .week
    @State private var selectedDataPoint: ChartDataPoint?
    
    /// 图表数据
    private var chartData: [ChartDataPoint] {
        let dailyData = StatisticsHelper.dailyCheckIns(from: logs, days: selectedRange.days)
        return dailyData.map { ChartDataPoint(date: $0.date, count: $0.count) }
    }
    
    /// 最大值（用于 Y 轴范围）
    private var maxCount: Int {
        max(chartData.map { $0.count }.max() ?? 1, 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和时间范围选择
            HStack {
                Text("打卡趋势")
                    .font(.headline)
                
                Spacer()
                
                Picker("时间范围", selection: $selectedRange) {
                    ForEach(ChartTimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
            
            // 图表
            Chart(chartData) { dataPoint in
                BarMark(
                    x: .value("日期", dataPoint.date, unit: .day),
                    y: .value("次数", dataPoint.count)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue.opacity(0.8), .blue.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(4)
            }
            .chartXAxis {
                if selectedRange == .week {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(weekdayLabel(for: date))
                                    .font(.caption2)
                            }
                        }
                    }
                } else {
                    AxisMarks(values: .stride(by: .day, count: 5)) { value in
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(dateLabel(for: date))
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let count = value.as(Int.self) {
                            Text("\(count)")
                                .font(.caption2)
                        }
                    }
                    AxisGridLine()
                }
            }
            .chartYScale(domain: 0...(maxCount + 1))
            .frame(height: 200)
            
            // 图表说明
            HStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 8, height: 8)
                Text("每日打卡次数")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("共 \(chartData.reduce(0) { $0 + $1.count }) 次")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func weekdayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    private func dateLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}

#Preview {
    CompletionChart(logs: [])
        .padding()
}