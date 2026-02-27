# habit-views Specification

## Purpose
TBD - created by archiving change habit-crud-views. Update Purpose after archive.
## Requirements
### Requirement: Habit List View

系统 **MUST** 提供习惯列表视图作为 App 主界面。

#### Scenario: 显示习惯列表

- **WHEN** 用户打开 App
- **THEN** 系统 **MUST** 显示所有已创建的习惯列表
- **AND** 每个习惯 **MUST** 显示名称、图标和主题色
- **AND** 列表 **MUST** 按创建时间倒序排列

#### Scenario: 空状态

- **WHEN** 用户没有任何习惯
- **THEN** 系统 **MUST** 显示空状态提示
- **AND** 提示 **MUST** 包含创建习惯的引导

#### Scenario: 添加习惯入口

- **WHEN** 用户在列表页面
- **THEN** 系统 **MUST** 提供添加习惯的按钮（导航栏右侧）

---

### Requirement: Habit Row View

系统 **MUST** 提供习惯行视图组件。

#### Scenario: 显示习惯信息

- **WHEN** 习惯显示在列表中
- **THEN** 行视图 **MUST** 显示习惯图标（带主题色背景）
- **AND** 行视图 **MUST** 显示习惯名称
- **AND** 行视图 **MUST** 显示今日完成状态

#### Scenario: 打卡操作

- **WHEN** 用户点击习惯行的打卡按钮
- **THEN** 系统 **MUST** 创建一条打卡记录
- **AND** 系统 **MUST** 显示成功反馈（动画 + 震动）

#### Scenario: 导航到编辑

- **WHEN** 用户点击习惯行（非打卡按钮区域）
- **THEN** 系统 **MUST** 导航到习惯编辑页面

---

### Requirement: Habit Form View

系统 **MUST** 提供习惯创建和编辑表单。

#### Scenario: 创建新习惯

- **WHEN** 用户点击添加按钮
- **THEN** 系统 **MUST** 显示空白表单
- **AND** 表单 **MUST** 包含：名称输入框、图标选择器、颜色选择器

#### Scenario: 编辑习惯

- **WHEN** 用户从列表导航到习惯详情
- **THEN** 系统 **MUST** 预填充现有习惯数据
- **AND** 用户 **MUST** 能够修改所有字段

#### Scenario: 保存习惯

- **WHEN** 用户填写完表单并点击保存
- **THEN** 系统 **MUST** 验证名称不为空
- **AND** 系统 **MUST** 保存习惯到数据库
- **AND** 系统 **MUST** 返回到列表页面

#### Scenario: 删除习惯

- **WHEN** 用户在编辑页面点击删除
- **THEN** 系统 **MUST** 显示确认对话框
- **AND** 确认后 **MUST** 删除习惯及其所有打卡记录

---

### Requirement: Icon Picker Component

系统 **MUST** 提供图标选择器组件。

#### Scenario: 显示图标网格

- **WHEN** 图标选择器显示
- **THEN** 系统 **MUST** 显示预设的 SF Symbols 图标网格
- **AND** 图标列表 **MUST** 包含至少 20 个常用图标

#### Scenario: 选择图标

- **WHEN** 用户点击某个图标
- **THEN** 系统 **MUST** 高亮选中的图标
- **AND** 系统 **MUST** 更新表单中的图标值

---

### Requirement: Color Picker Component

系统 **MUST** 提供颜色选择器组件。

#### Scenario: 显示颜色选项

- **WHEN** 颜色选择器显示
- **THEN** 系统 **MUST** 显示 6 种主题色
- **AND** 颜色 **MUST** 包含：海洋蓝、活力橙、清新绿、浪漫紫、温暖红、优雅黑

#### Scenario: 选择颜色

- **WHEN** 用户点击某个颜色
- **THEN** 系统 **MUST** 高亮选中的颜色
- **AND** 系统 **MUST** 更新表单中的颜色值

