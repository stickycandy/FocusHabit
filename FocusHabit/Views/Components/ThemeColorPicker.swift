//
//  ThemeColorPicker.swift
//  FocusHabit
//
//  颜色选择器组件
//

import SwiftUI

/// 主题颜色选择器
/// 显示 6 种主题色供用户选择
struct ThemeColorPicker: View {
    @Binding var selectedColor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.selectColor)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                ForEach(ThemeColor.allCases) { themeColor in
                    ColorButton(
                        themeColor: themeColor,
                        isSelected: selectedColor == themeColor.rawValue
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedColor = themeColor.rawValue
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

/// 单个颜色按钮
private struct ColorButton: View {
    let themeColor: ThemeColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(themeColor.color)
                    .frame(width: 44, height: 44)
                
                if isSelected {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.15 : 1.0)
        .shadow(color: isSelected ? themeColor.color.opacity(0.5) : .clear, radius: 8)
    }
}

#Preview {
    ThemeColorPicker(selectedColor: .constant("#007AFF"))
        .padding()
}