# Proposal: Habit CRUD Views

## Why

数据模型层已经完成，现在需要构建用户界面让用户能够创建、查看、编辑和删除习惯。这是 PRD 第 1-2 周的核心功能，也是整个 App 的主要交互入口。

## What Changes

- 创建习惯列表视图（首页主界面）
- 创建习惯详情/编辑表单视图
- 实现习惯的 CRUD 操作
- 添加图标选择器和颜色选择器组件
- 实现打卡功能的基础交互

## Capabilities

### New Capabilities
- `habit-list-view`: 展示所有习惯的列表视图，支持打卡操作
- `habit-form-view`: 创建和编辑习惯的表单视图
- `icon-picker`: 图标选择器组件（SF Symbols 预设库）
- `color-picker`: 颜色选择器组件（6 主题色）
- `habit-crud-operations`: 习惯的增删改查操作

## Impact

- `FocusHabit/Views/HabitListView.swift`: 习惯列表主视图
- `FocusHabit/Views/HabitRowView.swift`: 习惯列表行视图
- `FocusHabit/Views/HabitFormView.swift`: 习惯创建/编辑表单
- `FocusHabit/Views/Components/IconPicker.swift`: 图标选择器
- `FocusHabit/Views/Components/ColorPicker.swift`: 颜色选择器
- `FocusHabit/ContentView.swift`: 更新为使用 HabitListView