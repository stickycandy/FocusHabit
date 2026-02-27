//
//  ContentView.swift
//  FocusHabit
//
//  主视图入口
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @Bindable private var languageManager = LanguageManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HabitListView()
                .tabItem {
                    Label(L10n.tabHabits, systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Label(L10n.tabStatistics, systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            FocusTimerView()
                .tabItem {
                    Label(L10n.tabFocus, systemImage: "timer")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label(L10n.tabSettings, systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        // 监听语言变化以刷新 Tab 标签
        .id(languageManager.currentLanguage)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, HabitLog.self, FocusSession.self], inMemory: true)
}