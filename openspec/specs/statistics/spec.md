# Spec: Statistics and Charts

## ADDED Requirements

### Requirement: Statistics View

系统 **MUST** 提供统计数据主视图。

#### Scenario: 显示统计页面

- **WHEN** 用户切换到统计 Tab
- **THEN** 系统 **MUST** 显示数据摘要卡片区域
- **AND** 系统 **MUST** 显示完成率趋势图表
- **AND** 系统 **MUST** 显示日历热力图
- **AND** 系统 **MUST** 显示习惯排行榜

#### Scenario: 无数据状态

- **WHEN** 用户没有任何打卡记录
- **THEN** 系统 **MUST** 显示友好的空状态提示
- **AND** 提示 **MUST** 引导用户去打卡

---

### Requirement: Summary Cards

系统 **MUST** 提供数据摘要卡片组件。

#### Scenario: 显示核心指标

- **WHEN** 摘要卡片显示
- **THEN** 系统 **MUST** 显示总打卡次数
- **AND** 系统 **MUST** 显示今日完成数/总习惯数
- **AND** 系统 **MUST** 显示最长连续打卡天数
- **AND** 系统 **MUST** 显示本周完成率

---

### Requirement: Completion Chart

系统 **MUST** 提供完成率趋势图表。

#### Scenario: 显示近 7 天趋势

- **WHEN** 完成率图表显示
- **THEN** 系统 **MUST** 使用 Swift Charts 绘制柱状图
- **AND** X 轴 **MUST** 显示日期（近 7 天）
- **AND** Y 轴 **MUST** 显示完成次数
- **AND** 图表 **MUST** 支持点击查看详情

#### Scenario: 时间范围切换

- **WHEN** 用户切换时间范围
- **THEN** 系统 **MUST** 支持 7 天/30 天两种视图
- **AND** 数据 **MUST** 实时更新

---

### Requirement: Calendar Heatmap

系统 **MUST** 提供日历热力图组件。

#### Scenario: 显示月度热力图

- **WHEN** 日历热力图显示
- **THEN** 系统 **MUST** 显示当前月份的日历网格
- **AND** 每个日期 **MUST** 根据打卡次数显示不同深浅的颜色
- **AND** 无打卡的日期 **MUST** 显示浅灰色
- **AND** 系统 **MUST** 支持左右切换月份

#### Scenario: 打卡强度颜色

- **WHEN** 日期有打卡记录
- **THEN** 1-2 次 **SHALL** 显示浅色
- **AND** 3-4 次 **SHALL** 显示中等色
- **AND** 5 次以上 **SHALL** 显示深色

---

### Requirement: Habit Ranking

系统 **MUST** 提供习惯排行榜组件。

#### Scenario: 显示排行榜

- **WHEN** 习惯排行显示
- **THEN** 系统 **MUST** 按累计打卡次数降序排列
- **AND** 每个习惯 **MUST** 显示图标、名称、打卡次数
- **AND** 前三名 **MUST** 显示奖牌标识

---

### Requirement: Tab Navigation

系统 **MUST** 提供底部 Tab 导航。

#### Scenario: 切换 Tab

- **WHEN** App 显示
- **THEN** 底部 **MUST** 显示两个 Tab：首页、统计
- **AND** 用户 **MUST** 能够点击切换页面
- **AND** 当前 Tab **MUST** 高亮显示