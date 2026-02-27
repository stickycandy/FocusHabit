# Proposal: Project Init and Data Models

## Why

FocusHabit 是一个全新的 iOS App 项目，需要从零开始构建。数据模型层是整个应用的基础架构，所有功能（习惯追踪、专注计时、数据统计）都依赖于它。没有稳固的数据层，后续开发无法进行。

## What Changes

- 创建 Xcode 项目，配置 iOS 17+ 和 SwiftUI 框架
- 定义三个核心 SwiftData 模型：Habit、HabitLog、FocusSession
- 建立模型之间的关系（1:N 和可选关联）
- 搭建基础的 App 入口和数据容器

## Capabilities

### New Capabilities
- `data-models`: 定义 Habit、HabitLog、FocusSession 三个核心数据模型
- `data-persistence`: 使用 SwiftData 实现本地数据持久化
- `app-foundation`: 创建 App 入口点和模型容器

## Impact

- 创建新的 Xcode 项目结构
- `FocusHabitApp.swift`: App 入口 + ModelContainer 配置
- `Models/Habit.swift`: 习惯数据模型
- `Models/HabitLog.swift`: 打卡记录模型
- `Models/FocusSession.swift`: 专注记录模型