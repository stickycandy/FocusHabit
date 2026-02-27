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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HabitListView()
                .tabItem {
                    Label("习惯", systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            
            StatisticsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            FocusTimerView()
                .tabItem {
                    Label("专注", systemImage: "timer")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, HabitLog.self, FocusSession.self], inMemory: true)
}