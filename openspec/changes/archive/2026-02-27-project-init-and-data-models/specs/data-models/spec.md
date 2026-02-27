# Spec: Data Models

## ADDED Requirements

### Requirement: Habit Model

系统 **MUST** 定义习惯数据模型，包含习惯的基本信息和配置。

#### Scenario: 创建习惯

- **WHEN** 用户创建一个新习惯
- **THEN** 系统 **MUST** 存储习惯的 id、name、icon、color、reminderTimes、frequency、targetCount、createdAt
- **AND** id **MUST** 自动生成为 UUID
- **AND** createdAt **MUST** 自动设置为当前时间

#### Scenario: 习惯与打卡记录关联

- **WHEN** 习惯被创建后
- **THEN** 习惯 **MUST** 能关联多个 HabitLog 记录（1:N 关系）
- **AND** 删除习惯时 **MUST** 级联删除所有关联的打卡记录

---

### Requirement: HabitLog Model

系统 **MUST** 定义打卡记录数据模型，记录每次习惯完成情况。

#### Scenario: 创建打卡记录

- **WHEN** 用户完成习惯打卡
- **THEN** 系统 **MUST** 存储 id、habitId、completedAt、note
- **AND** id **MUST** 自动生成为 UUID
- **AND** completedAt **MUST** 自动设置为当前时间

#### Scenario: 打卡记录关联习惯

- **WHEN** 打卡记录被创建
- **THEN** 打卡记录 **MUST** 关联一个有效的 Habit（非空）

---

### Requirement: FocusSession Model

系统 **MUST** 定义专注记录数据模型，记录番茄钟专注会话。

#### Scenario: 创建专注记录

- **WHEN** 用户完成一次专注
- **THEN** 系统 **MUST** 存储 id、startTime、endTime、duration、status、relatedHabitId、rating
- **AND** id **MUST** 自动生成为 UUID
- **AND** duration **MUST** 以秒为单位存储

#### Scenario: 专注记录可选关联习惯

- **WHEN** 专注记录被创建
- **THEN** relatedHabitId **SHALL** 可以为空（不关联习惯）
- **OR** relatedHabitId **SHALL** 可以关联一个有效的 Habit

#### Scenario: 专注状态

- **WHEN** 专注记录被存储
- **THEN** status **MUST** 为以下之一：completed（完成）、cancelled（取消）、interrupted（中断）

---

### Requirement: App Foundation

系统 **MUST** 定义 App 入口和数据容器配置。

#### Scenario: App 启动

- **WHEN** App 启动时
- **THEN** 系统 **MUST** 初始化 SwiftData ModelContainer
- **AND** ModelContainer **MUST** 包含 Habit、HabitLog、FocusSession 三个模型
- **AND** 数据 **MUST** 持久化存储到本地