# Tasks: 专注音乐功能

## 任务清单

### 1. 创建 FocusMusicManager
- [x] 创建 `FocusMusicManager.swift` 管理器
- [x] 实现白噪音类型枚举 `WhiteNoiseType`（森林、雨声、海浪、虫鸣）
- [x] 实现音乐来源枚举 `MusicSource`
- [x] 实现 Apple Music 授权状态管理
- [x] 实现白噪音播放功能（AVAudioPlayer）
- [x] 实现 Apple Music 播放功能（MusicKit）
- [x] 实现音量控制
- [x] 实现专注开始/结束时的音乐处理逻辑

### 2. 创建音乐控制界面
- [x] 创建 `FocusMusicSheet.swift` Sheet 面板
- [x] 实现白噪音选择界面
- [x] 实现 Apple Music 授权与播放界面
- [x] 实现音量滑块控制
- [x] 实现播放控制按钮

### 3. 添加白噪音音频资源
- [x] 添加 `forest.mp3` 森林音效
- [x] 添加 `rain.mp3` 雨声音效
- [x] 添加 `ocean.mp3` 海浪音效
- [x] 添加 `crickets.mp3` 虫鸣音效

### 4. 添加本地化字符串
- [x] 添加所有支持语言的音乐相关字符串

### 5. 集成到专注页面
- [x] 在专注页面添加音乐按钮入口
- [x] 集成音乐播放状态与专注计时器

## 完成状态

✅ 所有任务已完成，专注音乐功能已正常运行。

## 文件变更摘要

| 文件 | 操作 |
|------|------|
| `FocusHabit/Managers/FocusMusicManager.swift` | 新建 |
| `FocusHabit/Views/Components/FocusMusic/FocusMusicSheet.swift` | 新建 |
| `FocusHabit/Resources/Audio/forest.mp3` | 新建 |
| `FocusHabit/Resources/Audio/rain.mp3` | 新建 |
| `FocusHabit/Resources/Audio/ocean.mp3` | 新建 |
| `FocusHabit/Resources/Audio/crickets.mp3` | 新建 |
| 各语言 `Localizable.strings` | 修改 |
