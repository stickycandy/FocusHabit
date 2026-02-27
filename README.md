# FocusHabit

> 🎯 专注习惯养成，用番茄钟提升效率

FocusHabit 是一款结合**习惯追踪**与**番茄钟计时**的 iOS 应用，帮助你养成良好习惯并保持专注。

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-orange)
![SwiftData](https://img.shields.io/badge/SwiftData-Enabled-green)
![License](https://img.shields.io/badge/License-Apache%202.0-blue)

## ✨ 功能特性

### 📋 习惯管理
- **创建习惯**：自定义名称、图标、主题色
- **灵活频率**：支持每日/每周任意天数设置
- **一键打卡**：快速记录习惯完成状态
- **滑动操作**：左滑编辑、右滑删除

### 📊 数据统计
- **趋势图表**：7天/30天完成率可视化 (Swift Charts)
- **日历热力图**：月视图展示打卡强度
- **数据汇总**：总打卡数、当前连续天数、完成率
- **习惯排行**：按完成次数排序的习惯榜单

### ⏱️ 专注计时器
- **番茄钟模式**：25分钟专注 + 5分钟短休息
- **长休息**：每4个番茄后自动触发15分钟长休息
- **习惯关联**：专注时段可关联到具体习惯
- **进度可视化**：环形进度条实时显示

### 🌍 多语言支持
- **三语切换**：简体中文 / 繁体中文 / English
- **应用内切换**：无需重启，实时生效
- **完整覆盖**：所有界面文案均已本地化
- **智能适配**：日期格式随语言自动调整（如 "2024年3月" vs "March 2024"）

### ⚙️ 设置中心
- **通知提醒**：自定义每日提醒时间
- **时长配置**：调整专注/休息时长
- **数据管理**：JSON 格式导出备份
- **深色模式**：跟随系统自动切换
- **语言设置**：应用内切换显示语言

## 📱 截图预览

| 习惯列表 | 统计分析 | 专注计时 | 设置 |
|:---:|:---:|:---:|:---:|
| 管理每日习惯 | 可视化数据 | 番茄钟计时 | 个性化配置 |

## 🛠️ 技术栈

- **UI 框架**: SwiftUI (iOS 17+)
- **数据持久化**: SwiftData
- **图表可视化**: Swift Charts
- **架构模式**: MVVM + @Observable
- **本地通知**: UserNotifications

## 📦 项目结构

```
FocusHabit/
├── FocusHabitApp.swift       # 应用入口
├── ContentView.swift         # TabView 主容器
├── Models/
│   ├── Habit.swift           # 习惯数据模型
│   ├── HabitLog.swift        # 打卡记录模型
│   ├── FocusSession.swift    # 专注会话模型
│   ├── AppSettings.swift     # 应用设置 (UserDefaults)
│   ├── FocusTimerManager.swift # 计时器状态管理
│   └── LanguageManager.swift # 多语言管理 (L10n)
├── Views/
│   ├── HabitListView.swift   # 习惯列表
│   ├── HabitFormView.swift   # 习惯编辑表单
│   ├── HabitRowView.swift    # 习惯行组件
│   ├── StatisticsView.swift  # 统计仪表盘
│   ├── FocusTimerView.swift  # 专注计时器
│   ├── Components/           # 可复用组件
│   │   ├── CompletionChart.swift
│   │   ├── CalendarHeatmap.swift
│   │   ├── CircularProgressView.swift
│   │   └── ...
│   └── Settings/             # 设置页面
│       ├── SettingsView.swift
│       ├── LanguageSettingsView.swift
│       ├── NotificationSettingsView.swift
│       └── ...
├── Resources/                # 本地化资源
│   ├── en.lproj/Localizable.strings
│   ├── zh-Hans.lproj/Localizable.strings
│   └── zh-Hant.lproj/Localizable.strings
└── Assets.xcassets/          # 资源文件
```

## 🚀 快速开始

### 环境要求

- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ (目标设备)

### 安装运行

1. **克隆仓库**
   ```bash
   git clone https://github.com/stickycandy/FocusHabit.git
   cd FocusHabit
   ```

2. **打开项目**
   ```bash
   open FocusHabit.xcodeproj
   ```

3. **运行应用**
   - 选择目标设备 (iPhone 模拟器或真机)
   - 点击 Run (⌘R)

## 📝 开发计划

- [x] 多语言支持（简体中文 / 繁体中文 / English）
- [ ] Widget 小组件支持
- [ ] iCloud 数据同步
- [ ] Apple Watch 配套应用
- [ ] 社交分享功能

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 开源协议

本项目基于 [Apache License 2.0](LICENSE) 开源。

## 🙏 致谢

- [SF Symbols](https://developer.apple.com/sf-symbols/) - 图标资源
- [Swift Charts](https://developer.apple.com/documentation/charts) - 图表框架

---

<p align="center">
  Made with ❤️ using SwiftUI
</p>