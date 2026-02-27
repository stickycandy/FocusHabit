# Design: Project Init and Data Models

## Context

FocusHabit 是一个全新的 iOS 项目，需要建立数据持久化层。根据 PRD 要求，目标平台是 iOS 17+，使用 SwiftUI 作为 UI 框架。

## Goals / Non-Goals

**Goals:**
- 创建可扩展的数据模型架构
- 使用 SwiftData 实现类型安全的数据持久化
- 建立清晰的模型关系

**Non-Goals:**
- 实现 iCloud 同步（后续版本）
- 实现数据迁移策略（MVP 阶段不需要）
- UI 视图层（后续任务）

## Decisions

### Decision 1: 使用 SwiftData 而非 CoreData

**选择：** SwiftData

**理由：**
- PRD 指定 iOS 17+，SwiftData 完全支持
- 比 CoreData 更简洁，使用 `@Model` 宏
- 与 SwiftUI 的 `@Query` 原生集成
- 类型安全，减少运行时错误

### Decision 2: 模型关系设计

**设计：**
```
Habit (1) ──────▶ (N) HabitLog
  │                    (级联删除)
  │
  ▼ (可选)
FocusSession ──▶ relatedHabit: Habit?
```

- Habit → HabitLog: 一对多，使用 `@Relationship` 配置级联删除
- FocusSession → Habit: 可选关联，使用 `Habit?` 类型

### Decision 3: 枚举类型

**FocusStatus 枚举：**
```swift
enum FocusStatus: String, Codable {
    case completed
    case cancelled
    case interrupted
}
```

使用 `String` 原始值便于存储和调试。

### Decision 4: 项目结构

```
FocusHabit/
├── FocusHabitApp.swift       # App 入口 + ModelContainer
├── Models/
│   ├── Habit.swift           # 习惯模型
│   ├── HabitLog.swift        # 打卡记录模型
│   └── FocusSession.swift    # 专注记录模型
├── Views/                    # (后续添加)
└── ViewModels/               # (后续添加)
```