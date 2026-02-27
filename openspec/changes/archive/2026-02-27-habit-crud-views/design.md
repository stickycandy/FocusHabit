# Design: Habit CRUD Views

## Context

基于已完成的 SwiftData 数据模型层，需要构建 SwiftUI 视图层。遵循 PRD 中的 UI/UX 设计规范，采用极简设计风格。

## Goals / Non-Goals

**Goals:**
- 创建美观、易用的习惯管理界面
- 实现完整的 CRUD 操作
- 提供打卡功能的基础交互
- 遵循 iOS 人机界面指南

**Non-Goals:**
- 复杂的动画效果（后续优化）
- 提醒时间设置功能（需要通知权限，后续版本）
- 重复频率设置（简化 MVP）

## Decisions

### Decision 1: 视图架构

**选择：** MVVM-lite（不引入独立 ViewModel）

**理由：**
- SwiftData 的 `@Query` 宏已经处理了数据绑定
- `@Environment(\.modelContext)` 提供了直接的数据操作
- 对于简单 CRUD，不需要额外的 ViewModel 层

### Decision 2: 导航模式

**选择：** NavigationStack + Sheet

```
HabitListView (NavigationStack)
├── 点击行 → NavigationLink → HabitFormView (编辑模式)
└── 点击 + → Sheet → HabitFormView (创建模式)
```

**理由：**
- 编辑使用 push 导航，符合 iOS 标准
- 创建使用 sheet，强调临时性操作

### Decision 3: 主题色定义

**颜色常量（根据 PRD）：**
```swift
enum ThemeColor: String, CaseIterable {
    case oceanBlue = "#007AFF"    // 海洋蓝
    case vitalOrange = "#FF9500"  // 活力橙
    case freshGreen = "#34C759"   // 清新绿
    case romanticPurple = "#AF52DE" // 浪漫紫
    case warmRed = "#FF3B30"      // 温暖红
    case elegantBlack = "#1C1C1E" // 优雅黑
}
```

### Decision 4: 预设图标

**常用习惯图标（SF Symbols）：**
```swift
let presetIcons = [
    "star.fill", "heart.fill", "book.fill", "dumbbell.fill",
    "cup.and.saucer.fill", "moon.fill", "sun.max.fill", "leaf.fill",
    "drop.fill", "flame.fill", "brain.head.profile", "figure.walk",
    "bed.double.fill", "fork.knife", "pills.fill", "cross.fill",
    "music.note", "paintbrush.fill", "gamecontroller.fill", "keyboard"
]
```

### Decision 5: 文件结构

```
FocusHabit/Views/
├── HabitListView.swift      # 习惯列表
├── HabitRowView.swift       # 列表行组件
├── HabitFormView.swift      # 创建/编辑表单
└── Components/
    ├── IconPicker.swift     # 图标选择器
    ├── ThemeColorPicker.swift # 颜色选择器
    └── Extensions/
        └── Color+Hex.swift  # 十六进制颜色扩展
```