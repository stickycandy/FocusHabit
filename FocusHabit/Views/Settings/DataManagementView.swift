//
//  DataManagementView.swift
//  FocusHabit
//
//  数据管理视图
//

import SwiftUI
import SwiftData

/// 数据管理视图
struct DataManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    @Query private var logs: [HabitLog]
    @Query private var sessions: [FocusSession]
    
    @State private var showingExportSheet = false
    @State private var showingResetAlert = false
    @State private var showingResetSettingsAlert = false
    @State private var exportedFileURL: URL?
    
    /// 数据统计
    private var habitCount: Int { habits.count }
    private var logCount: Int { logs.count }
    private var sessionCount: Int { sessions.count }
    
    var body: some View {
        Form {
            // 数据概览
            Section {
                DataRow(icon: "checkmark.circle.fill", color: .blue, title: L10n.habitCountLabel, value: "\(habitCount)")
                DataRow(icon: "calendar.badge.checkmark", color: .green, title: L10n.checkInRecords, value: "\(logCount)")
                DataRow(icon: "timer", color: .orange, title: L10n.focusRecords, value: "\(sessionCount)")
            } header: {
                Text(L10n.dataOverview)
            }
            
            // 导出数据
            Section {
                Button {
                    exportData()
                } label: {
                    Label(L10n.exportData, systemImage: "square.and.arrow.up")
                }
                .disabled(habitCount == 0 && logCount == 0)
            } header: {
                Text(L10n.dataExport)
            } footer: {
                Text(L10n.dataExportDesc)
            }
            
            // 危险操作
            Section {
                // 重置设置
                Button(role: .destructive) {
                    showingResetSettingsAlert = true
                } label: {
                    Label(L10n.resetSettings, systemImage: "gearshape.arrow.triangle.2.circlepath")
                }
                
                // 清除所有数据
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label(L10n.clearAllData, systemImage: "trash.fill")
                }
            } header: {
                Text(L10n.dangerZone)
            } footer: {
                Text(L10n.dangerZoneDesc)
            }
        }
        .navigationTitle(L10n.dataManagement)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingExportSheet) {
            if let url = exportedFileURL {
                ShareSheet(items: [url])
            }
        }
        .alert(L10n.resetSettings, isPresented: $showingResetSettingsAlert) {
            Button(L10n.cancel, role: .cancel) {}
            Button(L10n.reset, role: .destructive) {
                AppSettings.shared.resetToDefaults()
            }
        } message: {
            Text(L10n.resetSettingsConfirm)
        }
        .alert(L10n.clearAllData, isPresented: $showingResetAlert) {
            Button(L10n.cancel, role: .cancel) {}
            Button(L10n.clear, role: .destructive) {
                clearAllData()
            }
        } message: {
            Text(L10n.clearDataConfirm)
        }
    }
    
    // MARK: - 导出数据
    
    private func exportData() {
        let exportData = ExportData(
            exportDate: Date(),
            habits: habits.map { habit in
                ExportHabit(
                    id: habit.id.uuidString,
                    name: habit.name,
                    icon: habit.icon,
                    color: habit.color,
                    targetCount: habit.targetCount,
                    frequency: habit.frequency,
                    createdAt: habit.createdAt
                )
            },
            logs: logs.map { log in
                ExportLog(
                    id: log.id.uuidString,
                    habitId: log.habit?.id.uuidString ?? "",
                    completedAt: log.completedAt,
                    note: log.note
                )
            },
            sessions: sessions.map { session in
                ExportSession(
                    id: session.id.uuidString,
                    habitId: session.relatedHabit?.id.uuidString,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    duration: session.duration,
                    isCompleted: session.status == .completed
                )
            }
        )
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(exportData)
            
            // 保存到临时文件
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let fileName = "FocusHabit_\(formatter.string(from: Date())).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try data.write(to: tempURL)
            exportedFileURL = tempURL
            showingExportSheet = true
        } catch {
            print("导出失败: \(error)")
        }
    }
    
    // MARK: - 清除数据
    
    private func clearAllData() {
        // 删除所有习惯（会级联删除打卡记录）
        for habit in habits {
            modelContext.delete(habit)
        }
        
        // 删除所有专注记录
        for session in sessions {
            modelContext.delete(session)
        }
        
        try? modelContext.save()
    }
}

// MARK: - 数据行组件

private struct DataRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - 导出数据模型

private struct ExportData: Codable {
    let exportDate: Date
    let habits: [ExportHabit]
    let logs: [ExportLog]
    let sessions: [ExportSession]
}

private struct ExportHabit: Codable {
    let id: String
    let name: String
    let icon: String
    let color: String
    let targetCount: Int
    let frequency: [Int]
    let createdAt: Date
}

private struct ExportLog: Codable {
    let id: String
    let habitId: String
    let completedAt: Date
    let note: String?
}

private struct ExportSession: Codable {
    let id: String
    let habitId: String?
    let startTime: Date
    let endTime: Date?
    let duration: Int
    let isCompleted: Bool
}

// MARK: - 分享 Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        DataManagementView()
    }
    .modelContainer(for: [Habit.self, HabitLog.self, FocusSession.self], inMemory: true)
}