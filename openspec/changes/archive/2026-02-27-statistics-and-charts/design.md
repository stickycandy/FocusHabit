# Design: Statistics and Charts

## Context

习惯 CRUD 功能已完成，现在需要添加数据可视化功能。根据 PRD，需要使用 Swift Charts 实现图表，并提供日历视图展示打卡分布。

## Goals / Non-Goals

**Goals:**
- 创建美观、信息丰富的统计页面
- 使用 Swift Charts 实现原生图表
- 实现日历热力图展示打卡强度
- 提供清晰的数据摘要

**Non-Goals:**
- 数据导出功能（后续版本）
- 详细的报表生成（超出 MVP 范围）
- 专注时长统计（番茄钟功能尚未实现）

## Decisions

### Decision 1: App 导航结构

**选择：** TabView 底部导航

**结构：**
```
TabView
├── Tab 1: 首页 (HabitListView)
│   icon: "house.fill"
└── Tab 2: 统计 (StatisticsView)
    icon: "chart.bar.fill"
```

**理由：**
- PRD 中提到底部 Tab 导航
- 两个核心功能区域清晰分离

### Decision 2: 统计页面布局

**选择：** ScrollView + LazyVStack

**布局：**
```
StatisticsView
├── 摘要卡片区域 (HStack - 4 个卡片)
├── 完成率图表 (Swift Charts)
├── 日历热力图
└── 习惯排行榜
```

### Decision 3: 日历热力图实现

**选择：** 自定义 SwiftUI Grid

**颜色强度分级：**
```swift
enum HeatmapIntensity {
    case none      // 灰色 - 0 次
    case low       // 浅绿 - 1-2 次
    case medium    // 中绿 - 3-4 次
    case high      // 深绿 - 5+ 次
}
```

### Decision 4: 数据计算

**统计指标：**
```swift
struct StatisticsSummary {
    var totalCheckIns: Int           // 总打卡次数
    var todayCompleted: Int          // 今日完成数
    var totalHabits: Int             // 总习惯数
    var longestStreak: Int           // 最长连续天数
    var weeklyCompletionRate: Double // 本周完成率
}
```

**计算逻辑：**
- 连续天数：遍历 logs，找最长连续日期序列
- 完成率：(实际完成次数 / 应完成次数) × 100%

### Decision 5: 文件结构

```
FocusHabit/Views/
├── ContentView.swift              # TabView 容器
├── HabitListView.swift            # (已有)
├── StatisticsView.swift           # 统计主视图
└── Components/
    ├── SummaryCard.swift          # 摘要卡片
    ├── CompletionChart.swift      # 完成率图表
    ├── CalendarHeatmap.swift      # 日历热力图
    └── HabitRankingView.swift     # 习惯排行
```