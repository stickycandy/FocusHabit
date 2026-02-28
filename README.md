# 📱 FocusHabit

<p align="center">
  <img src="FocusHabit/Assets.xcassets/AppIcon.appiconset/AppIcon-Light.png" width="120" alt="FocusHabit Logo">
</p>

<p align="center">
  <strong>习惯养成 + 专注计时，双引擎驱动你的成长</strong>
</p>

<p align="center">
  <a href="#功能特性">功能特性</a> •
  <a href="#截图预览">截图预览</a> •
  <a href="#技术栈">技术栈</a> •
  <a href="#安装运行">安装运行</a> •
  <a href="#项目结构">项目结构</a> •
  <a href="#国际化">国际化</a> •
  <a href="#许可证">许可证</a>
</p>

---

## ✨ 功能特性

### 🎯 习惯追踪
- **灵活创建** - 自定义习惯名称、图标、颜色和提醒时间
- **多种频率** - 支持每日、每周特定几天等重复模式
- **轻松打卡** - 点击打卡，专注完成后自动打卡
- **即时反馈** - 粒子动画效果 + 震动反馈 + 鼓励语录

### ⏱️ 专注计时（番茄钟）
- **番茄工作法** - 默认 25 分钟专注 + 5 分钟休息
- **自定义时长** - 15-60 分钟可调，满足不同需求
- **白噪音陪伴** - 雨声 🌧️ | 海浪 🌊 | 森林 🌲 | 蟋蟀 🦗
- **专注记录** - 记录每次专注时长、评分和关联习惯

### 📊 数据统计
- **日历热力图** - 直观展示打卡情况
- **完成率图表** - 追踪习惯养成进度
- **习惯排行** - 查看最坚持的习惯
- **趋势分析** - 了解专注时间分布

### 🎨 个性化体验
- **6 种主题色** - 海洋蓝、活力橙、清新绿、浪漫紫、温暖红、优雅黑
- **深色模式** - 完美适配系统深色模式
- **多语言支持** - 中文、英文、日语、韩语、德语、泰语

---

## �️ 技术栈

| 模块 | 技术选型 |
|------|---------|
| 开发语言 | Swift 5.9+ |
| UI 框架 | SwiftUI |
| 数据持久化 | SwiftData |
| 图表库 | Swift Charts |
| 最低版本 | iOS 17.0+ |

---

## 🚀 安装运行

### 环境要求
- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ (模拟器或真机)

### 步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/your-username/FocusHabit.git
   cd FocusHabit
   ```

2. **打开项目**
   ```bash
   open FocusHabit.xcodeproj
   ```

3. **选择目标设备**
   - 在 Xcode 中选择 iPhone 模拟器或已连接的真机

4. **运行项目**
   - 点击 ▶️ 运行按钮，或按 `Cmd + R`

---

## � 项目结构

```
FocusHabit/
├── FocusHabitApp.swift          # App 入口
├── ContentView.swift            # 主视图（Tab 导航）
├── Models/                      # 数据模型
│   ├── Habit.swift              # 习惯模型
│   ├── HabitLog.swift           # 打卡记录模型
│   ├── FocusSession.swift       # 专注记录模型
│   ├── AppSettings.swift        # 应用设置
│   ├── FocusTimerManager.swift  # 专注计时器管理
│   └── LanguageManager.swift    # 语言管理
├── Views/                       # 视图层
│   ├── HabitListView.swift      # 习惯列表页
│   ├── HabitFormView.swift      # 习惯表单页
│   ├── HabitRowView.swift       # 习惯行组件
│   ├── FocusTimerView.swift     # 专注计时页
│   ├── StatisticsView.swift     # 统计页面
│   ├── Components/              # 通用组件
│   │   ├── CalendarHeatmap.swift    # 日历热力图
│   │   ├── CircularProgressView.swift # 环形进度
│   │   ├── CompletionChart.swift    # 完成率图表
│   │   ├── HabitRankingView.swift   # 习惯排行
│   │   ├── IconPicker.swift         # 图标选择器
│   │   ├── ThemeColorPicker.swift   # 主题色选择器
│   │   └── FocusMusic/              # 专注音乐组件
│   └── Settings/                # 设置页面
│       ├── SettingsView.swift       # 设置主页
│       ├── FocusSettingsView.swift  # 专注设置
│       ├── NotificationSettingsView.swift # 通知设置
│       ├── LanguageSettingsView.swift    # 语言设置
│       ├── DataManagementView.swift      # 数据管理
│       └── AboutView.swift          # 关于页面
├── Managers/                    # 管理器
│   └── FocusMusicManager.swift  # 白噪音管理
├── Resources/                   # 资源文件
│   ├── Audio/                   # 白噪音音频
│   │   ├── rain.mp3
│   │   ├── ocean.mp3
│   │   ├── forest.mp3
│   │   └── crickets.mp3
│   ├── zh-Hans.lproj/           # 简体中文
│   ├── zh-Hant.lproj/           # 繁体中文
│   ├── en.lproj/                # 英语
│   ├── ja.lproj/                # 日语
│   ├── ko.lproj/                # 韩语
│   ├── de.lproj/                # 德语
│   └── th.lproj/                # 泰语
└── Assets.xcassets/             # 资源目录
    └── AppIcon.appiconset/      # 应用图标
```

---

## 🌍 国际化

FocusHabit 支持以下语言：

| 语言 | 代码 | 状态 |
|------|------|------|
| 简体中文 | zh-Hans | ✅ |
| 繁体中文 | zh-Hant | ✅ |
| English | en | ✅ |
| 日本語 | ja | ✅ |
| 한국어 | ko | ✅ |
| Deutsch | de | ✅ |
| ภาษาไทย | th | ✅ |

### 添加新语言

1. 在 `FocusHabit/Resources/` 下创建新的 `.lproj` 目录
2. 复制 `en.lproj/Localizable.strings` 到新目录
3. 翻译所有字符串
4. 在 `LanguageManager.swift` 中注册新语言

---

## 🎯 未来规划

- [ ] 小组件支持（Widget）
- [ ] iCloud 数据同步
- [ ] 成就系统与徽章墙
- [ ] Apple Watch 支持
- [ ] 社交分享功能
- [ ] 更多白噪音选择

---

## 📄 许可证

本项目采用 [Apache License 2.0](LICENSE) 许可证。

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

---

<p align="center">
  Made with ❤️ using SwiftUI
</p>