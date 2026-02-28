//
//  CalendarHeatmap.swift
//  FocusHabit
//
//  日历热力图组件
//

import SwiftUI

/// 日历热力图
struct CalendarHeatmap: View {
    let logs: [HabitLog]
    @State private var displayedMonth: Date = Date()
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    /// 本地化的星期符号
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = LanguageManager.shared.currentLanguage.locale
        return formatter.veryShortWeekdaySymbols
    }
    
    /// 当月打卡数据
    private var monthlyData: [Int: Int] {
        StatisticsHelper.monthlyCheckIns(from: logs, for: displayedMonth)
    }
    
    /// 当月天数
    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 30
    }
    
    /// 当月第一天是星期几（0 = 周日）
    private var firstWeekday: Int {
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else {
            return 0
        }
        return calendar.component(.weekday, from: firstDay) - 1
    }
    
    /// 月份标题
    private var monthTitle: String {
        let formatter = DateFormatter()
        let language = LanguageManager.shared.currentLanguage
        formatter.locale = language.locale
        switch language {
        case .zhHans, .zhHant:
            formatter.dateFormat = "yyyy年M月"
        case .en:
            formatter.dateFormat = "MMMM yyyy"
        case .de:
            formatter.dateFormat = "MMMM yyyy"
        case .ko:
            formatter.dateFormat = "yyyy년 M월"
        case .ja:
            formatter.dateFormat = "yyyy年M月"
        case .th:
            formatter.dateFormat = "MMMM yyyy"
        }
        return formatter.string(from: displayedMonth)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题和月份导航
            HStack {
                Text(L10n.checkInCalendar)
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button {
                        withAnimation {
                            displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                    }
                    
                    Text(monthTitle)
                        .font(.subheadline)
                        .frame(minWidth: 80)
                    
                    Button {
                        withAnimation {
                            displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .disabled(calendar.isDate(displayedMonth, equalTo: Date(), toGranularity: .month))
                }
            }
            
            // 星期标题
            HStack(spacing: 4) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 日历格子
            LazyVGrid(columns: columns, spacing: 4) {
                // 空白占位
                ForEach(0..<firstWeekday, id: \.self) { _ in
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                }
                
                // 日期格子
                ForEach(1...daysInMonth, id: \.self) { day in
                    DayCell(
                        day: day,
                        count: monthlyData[day] ?? 0,
                        isToday: isToday(day: day)
                    )
                }
            }
            
            // 图例
            HStack {
                Text(L10n.less)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                ForEach([0, 1, 2, 3, 4], id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(heatColor(for: level))
                        .frame(width: 12, height: 12)
                }
                
                Text(L10n.more)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                let totalCount = monthlyData.values.reduce(0, +)
                Text(L10n.monthlyTotal(totalCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    /// 判断是否是今天
    private func isToday(day: Int) -> Bool {
        let today = Date()
        return calendar.isDate(displayedMonth, equalTo: today, toGranularity: .month) &&
               calendar.component(.day, from: today) == day
    }
    
    /// 根据打卡次数返回热力颜色
    private func heatColor(for count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray5)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green.opacity(0.9)
        }
    }
}

/// 日期单元格
private struct DayCell: View {
    let day: Int
    let count: Int
    let isToday: Bool
    
    private var backgroundColor: Color {
        switch count {
        case 0: return Color(.systemGray5)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green.opacity(0.9)
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
                .aspectRatio(1, contentMode: .fill)
            
            Text("\(day)")
                .font(.caption2)
                .foregroundStyle(count > 0 ? .white : .secondary)
            
            if isToday {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.blue, lineWidth: 2)
            }
        }
    }
}

#Preview {
    CalendarHeatmap(logs: [])
        .padding()
}