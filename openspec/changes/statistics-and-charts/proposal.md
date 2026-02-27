# Proposal: Statistics and Charts

## Why

用户需要直观地看到自己的习惯养成进展和成长轨迹。数据可视化是激励用户坚持的重要手段，也是 PRD 中"数据可视化 - 清晰看到成长和进步"的核心价值体现。

## What Changes

- 创建统计主视图（Tab 页面）
- 实现日历热力图（打卡分布）
- 实现完成率图表（使用 Swift Charts）
- 实现习惯排行榜
- 添加周报/月报数据汇总

## Capabilities

### New Capabilities
- `statistics-view`: 统计数据主视图，汇总展示各类数据
- `calendar-heatmap`: 日历热力图，展示打卡频率分布
- `completion-chart`: 完成率趋势图表（近 7 天/30 天）
- `habit-ranking`: 习惯排行榜，按坚持天数排序
- `summary-cards`: 数据摘要卡片（总打卡、连续天数等）

## Impact

- `FocusHabit/Views/StatisticsView.swift`: 统计主视图
- `FocusHabit/Views/Components/CalendarHeatmap.swift`: 日历热力图
- `FocusHabit/Views/Components/CompletionChart.swift`: 完成率图表
- `FocusHabit/Views/Components/SummaryCard.swift`: 数据摘要卡片
- `FocusHabit/Views/Components/HabitRankingView.swift`: 习惯排行
- `FocusHabit/ContentView.swift`: 改为 TabView 布局