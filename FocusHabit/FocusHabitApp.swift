//
//  FocusHabitApp.swift
//  FocusHabit
//
//  App 入口 + ModelContainer 配置
//

import SwiftUI
import SwiftData

@main
struct FocusHabitApp: App {
    /// SwiftData ModelContainer
    /// 包含 Habit、HabitLog、FocusSession 三个模型
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            HabitLog.self,
            FocusSession.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false  // 持久化存储到本地
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)  // 注入到 SwiftUI 环境
    }
}