# Tasks: Project Init and Data Models

## 1. 项目搭建

- [x] 1.1 创建 FocusHabit Xcode 项目 (iOS App, SwiftUI, SwiftData)
- [x] 1.2 配置项目最低部署版本为 iOS 17.0
- [x] 1.3 创建 Models 文件夹结构

## 2. 数据模型

- [x] 2.1 创建 Habit.swift 模型
- [x] 2.2 创建 HabitLog.swift 模型
- [x] 2.3 创建 FocusSession.swift 模型（含 FocusStatus 枚举）
- [x] 2.4 配置模型关系（Habit ↔ HabitLog, FocusSession → Habit）

## 3. App 入口配置

- [x] 3.1 在 FocusHabitApp.swift 中配置 ModelContainer
- [x] 3.2 将 ModelContainer 注入到 SwiftUI 环境

## 4. 验证

- [x] 4.1 确保项目可以编译运行
- [x] 4.2 验证 SwiftData 模型被正确识别