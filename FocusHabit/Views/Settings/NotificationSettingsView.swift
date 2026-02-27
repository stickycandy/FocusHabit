//
//  NotificationSettingsView.swift
//  FocusHabit
//
//  通知设置视图
//

import SwiftUI
import UserNotifications

/// 通知设置视图
struct NotificationSettingsView: View {
    @Bindable private var settings = AppSettings.shared
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var showingPermissionAlert = false
    
    var body: some View {
        Form {
            Section {
                // 通知总开关
                Toggle(isOn: $settings.notificationsEnabled) {
                    Label("启用通知", systemImage: "bell.fill")
                }
                .onChange(of: settings.notificationsEnabled) { _, newValue in
                    if newValue {
                        requestNotificationPermission()
                    }
                }
                
                // 权限状态
                if settings.notificationsEnabled {
                    HStack {
                        Text("权限状态")
                        Spacer()
                        Text(permissionStatusText)
                            .foregroundStyle(permissionStatusColor)
                    }
                }
            } header: {
                Text("通知开关")
            } footer: {
                Text("开启后，应用将在设定的时间提醒您打卡")
            }
            
            if settings.notificationsEnabled && notificationStatus == .authorized {
                Section {
                    // 每日提醒时间
                    DatePicker(
                        "每日提醒时间",
                        selection: $settings.dailyReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    // 提示音
                    Toggle(isOn: $settings.soundEnabled) {
                        Label("提示音", systemImage: "speaker.wave.2.fill")
                    }
                    
                    // 振动
                    Toggle(isOn: $settings.vibrationEnabled) {
                        Label("振动", systemImage: "iphone.radiowaves.left.and.right")
                    }
                } header: {
                    Text("提醒设置")
                }
            }
        }
        .navigationTitle("通知设置")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkNotificationStatus()
        }
        .alert("需要通知权限", isPresented: $showingPermissionAlert) {
            Button("去设置") {
                openAppSettings()
            }
            Button("取消", role: .cancel) {
                settings.notificationsEnabled = false
            }
        } message: {
            Text("请在系统设置中开启通知权限，以便接收打卡提醒")
        }
    }
    
    // MARK: - 权限状态
    
    private var permissionStatusText: String {
        switch notificationStatus {
        case .notDetermined: return "未设置"
        case .denied: return "已拒绝"
        case .authorized: return "已授权"
        case .provisional: return "临时授权"
        case .ephemeral: return "临时授权"
        @unknown default: return "未知"
        }
    }
    
    private var permissionStatusColor: Color {
        switch notificationStatus {
        case .authorized, .provisional, .ephemeral: return .green
        case .denied: return .red
        default: return .secondary
        }
    }
    
    // MARK: - 方法
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationStatus = settings.authorizationStatus
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                checkNotificationStatus()
                if !granted {
                    showingPermissionAlert = true
                }
            }
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}