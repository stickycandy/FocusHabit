//
//  IconPicker.swift
//  FocusHabit
//
//  图标选择器组件
//

import SwiftUI

/// 图标选择器
/// 显示预设的 SF Symbols 图标网格供用户选择
struct IconPicker: View {
    @Binding var selectedIcon: String
    let themeColor: Color
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 6)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择图标")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(PresetIcons.all, id: \.self) { icon in
                    IconButton(
                        icon: icon,
                        isSelected: selectedIcon == icon,
                        themeColor: themeColor
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedIcon = icon
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

/// 单个图标按钮
private struct IconButton: View {
    let icon: String
    let isSelected: Bool
    let themeColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .foregroundStyle(isSelected ? .white : .primary)
                .background(isSelected ? themeColor : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? themeColor : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.1 : 1.0)
    }
}

#Preview {
    IconPicker(selectedIcon: .constant("star.fill"), themeColor: .blue)
        .padding()
}