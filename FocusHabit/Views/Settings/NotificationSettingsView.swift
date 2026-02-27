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
                    Label(L10n.enableNotifications, systemImage: "bell.fill")
                }
                .onChange(of: settings.notificationsEnabled) { _, newValue in
                    if newValue {
                        requestNotificationPermission()
                    }
                }
                
                // 权限状态
                if settings.notificationsEnabled {
                    HStack {
                        Text(L10n.permissionStatus)
                        Spacer()
                        Text(permissionStatusText)
                            .foregroundStyle(permissionStatusColor)
                    }
                }
            } header: {
                Text(L10n.notificationSwitch)
            } footer: {
                Text(L10n.notificationSwitchDesc)
            }
            
            if settings.notificationsEnabled && notificationStatus == .authorized {
                Section {
                    // 每日提醒时间
                    DatePicker(
                        L10n.reminderSettings,
                        selection: $settings.dailyReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    
                    // 提示音
                    Toggle(isOn: $settings.soundEnabled) {
                        Label(L10n.sound, systemImage: "speaker.wave.2.fill")
                    }
                    
                    // 振动
                    Toggle(isOn: $settings.vibrationEnabled) {
                        Label(L10n.vibration, systemImage: "iphone.radiowaves.left.and.right")
                    }
                } header: {
                    Text(L10n.reminderSettings)
                }
            }
        }
        .navigationTitle(L10n.notificationSettings)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkNotificationStatus()
        }
        .alert(L10n.enableNotifications, isPresented: $showingPermissionAlert) {
            Button(L10n.settings) {
                openAppSettings()
            }
            Button(L10n.cancel, role: .cancel) {
                settings.notificationsEnabled = false
            }
        } message: {
            Text(L10n.notificationPermissionHint)
        }
    }
    
    // MARK: - 权限状态
    
    private var permissionStatusText: String {
        let manager = LanguageManager.shared
        switch notificationStatus {
        case .notDetermined: return manager.localizedString("permission_not_determined")
        case .denied: return manager.localizedString("permission_denied")
        case .authorized: return manager.localizedString("permission_authorized")
        case .provisional: return manager.localizedString("permission_provisional")
        case .ephemeral: return manager.localizedString("permission_provisional")
        @unknown default: return manager.localizedString("permission_unknown")
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