//
//  LanguageSettingsView.swift
//  FocusHabit
//
//  语言设置页面
//

import SwiftUI

/// 语言设置视图
struct LanguageSettingsView: View {
    @Bindable private var languageManager = LanguageManager.shared
    
    var body: some View {
        List {
            Section {
                ForEach(AppLanguage.allCases) { language in
                    LanguageRow(
                        language: language,
                        isSelected: languageManager.currentLanguage == language
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            languageManager.currentLanguage = language
                        }
                    }
                }
            } footer: {
                Text(L10n.languageSettingsFooter)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(L10n.languageSettings)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 语言行组件

private struct LanguageRow: View {
    let language: AppLanguage
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(language.localizedName)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        LanguageSettingsView()
    }
}
