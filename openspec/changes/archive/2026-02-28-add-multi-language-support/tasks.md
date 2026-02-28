# Tasks: 添加多语言支持

## 任务清单

### 1. 修改 LanguageManager.swift
- [x] 在 `AppLanguage` enum 中添加 4 个新 case：`.de`, `.ko`, `.ja`, `.th`
- [x] 更新 `localizedName` 属性，为每种语言返回本地名称
- [x] 更新 `formatDate()` 方法，添加各语言的日期格式
- [x] 更新 `detectSystemLanguage()` 方法，支持新语言的自动检测

### 2. 创建德语本地化文件
- [x] 创建 `FocusHabit/Resources/de.lproj/` 目录
- [x] 创建 `Localizable.strings` 文件并翻译所有字符串

### 3. 创建韩语本地化文件
- [x] 创建 `FocusHabit/Resources/ko.lproj/` 目录
- [x] 创建 `Localizable.strings` 文件并翻译所有字符串

### 4. 创建日语本地化文件
- [x] 创建 `FocusHabit/Resources/ja.lproj/` 目录
- [x] 创建 `Localizable.strings` 文件并翻译所有字符串

### 5. 创建泰语本地化文件
- [x] 创建 `FocusHabit/Resources/th.lproj/` 目录
- [x] 创建 `Localizable.strings` 文件并翻译所有字符串

### 6. 更新 Xcode 项目配置
- [x] 确保新建的 `.lproj` 目录被正确添加到项目中

### 7. 修复编译错误
- [x] 修复 `CalendarHeatmap.swift` 中 switch 语句缺少新语言 case 的问题

## 完成状态

✅ 所有任务已完成，项目已成功编译并在模拟器中测试通过。

## 文件变更摘要

| 文件 | 操作 |
|------|------|
| `FocusHabit/Models/LanguageManager.swift` | 修改 |
| `FocusHabit/Resources/de.lproj/Localizable.strings` | 新建 |
| `FocusHabit/Resources/ko.lproj/Localizable.strings` | 新建 |
| `FocusHabit/Resources/ja.lproj/Localizable.strings` | 新建 |
| `FocusHabit/Resources/th.lproj/Localizable.strings` | 新建 |
| `FocusHabit/Views/Components/CalendarHeatmap.swift` | 修改 |