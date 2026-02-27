//
//  AppIconGenerator.swift
//  FocusHabit
//
//  应用图标生成器 - 用于预览和导出图标
//  使用方法：在 Xcode Preview 中截图导出 1024x1024 图片
//

import SwiftUI

/// 应用图标视图
struct AppIconView: View {
    /// 是否使用深色模式
    let isDarkMode: Bool
    
    /// 图标尺寸
    let size: CGFloat
    
    // 预定义颜色
    private var lightGradientColors: [Color] {
        [Color(hex: "#667EEA") ?? .purple, Color(hex: "#764BA2") ?? .purple]
    }
    
    private var darkGradientColors: [Color] {
        [Color(hex: "#1C1C1E") ?? .black, Color(hex: "#2C2C2E") ?? .gray]
    }
    
    private var lightProgressColors: [Color] {
        [Color(hex: "#FFD60A") ?? .yellow, Color(hex: "#FF9F0A") ?? .orange]
    }
    
    private var darkProgressColors: [Color] {
        [Color(hex: "#34C759") ?? .green, Color(hex: "#30D158") ?? .green]
    }
    
    var body: some View {
        ZStack {
            // 背景
            RoundedRectangle(cornerRadius: size * 0.2237)
                .fill(
                    LinearGradient(
                        colors: isDarkMode ? darkGradientColors : lightGradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 主图标元素
            ZStack {
                // 外圈 - 习惯追踪圆环
                Circle()
                    .stroke(
                        isDarkMode ? Color.white.opacity(0.9) : Color.white.opacity(0.95),
                        style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round)
                    )
                    .frame(width: size * 0.55, height: size * 0.55)
                
                // 进度弧线 - 表示完成度
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        isDarkMode
                            ? LinearGradient(colors: darkProgressColors, startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: lightProgressColors, startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: size * 0.06, lineCap: .round)
                    )
                    .frame(width: size * 0.55, height: size * 0.55)
                    .rotationEffect(.degrees(-90))
                
                // 中心勾选标记
                Image(systemName: "checkmark")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundStyle(isDarkMode ? .white : .white)
            }
        }
        .frame(width: size, height: size)
    }
}

/// 图标生成器预览页面
struct AppIconGenerator: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("FocusHabit 应用图标")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 浅色模式图标
                VStack(spacing: 12) {
                    Text("浅色模式 (Light)")
                        .font(.headline)
                    
                    AppIconView(isDarkMode: false, size: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 200 * 0.2237))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Text("用于主图标")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // 深色模式图标
                VStack(spacing: 12) {
                    Text("深色模式 (Dark)")
                        .font(.headline)
                    
                    AppIconView(isDarkMode: true, size: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 200 * 0.2237))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("用于深色主题")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .padding(.horizontal)
                
                // 1024x1024 导出预览
                VStack(spacing: 20) {
                    Text("导出尺寸预览 (1024x1024)")
                        .font(.headline)
                    
                    Text("在 Preview Canvas 中右键选择\n\"Export Preview\" 导出图片")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 40)
        }
    }
}

// MARK: - 1024x1024 导出用预览

/// 浅色图标 1024x1024 - 用于导出
struct LightAppIcon_1024: View {
    var body: some View {
        AppIconView(isDarkMode: false, size: 1024)
    }
}

/// 深色图标 1024x1024 - 用于导出
struct DarkAppIcon_1024: View {
    var body: some View {
        AppIconView(isDarkMode: true, size: 1024)
    }
}

// MARK: - Previews

#Preview("图标生成器") {
    AppIconGenerator()
}

#Preview("Light Icon 1024x1024") {
    LightAppIcon_1024()
        .frame(width: 1024, height: 1024)
}

#Preview("Dark Icon 1024x1024") {
    DarkAppIcon_1024()
        .frame(width: 1024, height: 1024)
}