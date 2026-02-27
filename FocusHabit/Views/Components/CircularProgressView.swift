//
//  CircularProgressView.swift
//  FocusHabit
//
//  环形进度条组件
//

import SwiftUI

/// 环形进度条
struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    
    /// 渐变颜色
    private var gradient: AngularGradient {
        AngularGradient(
            colors: [color.opacity(0.3), color],
            center: .center,
            startAngle: .degrees(-90),
            endAngle: .degrees(270)
        )
    }
    
    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(
                    color.opacity(0.2),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // 进度圆环
            Circle()
                .trim(from: 0, to: min(progress, 1))
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}

/// 带内容的环形进度条
struct CircularProgressWithContent<Content: View>: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    @ViewBuilder let content: () -> Content
    
    init(
        progress: Double,
        color: Color,
        lineWidth: CGFloat = 12,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.progress = progress
        self.color = color
        self.lineWidth = lineWidth
        self.content = content
    }
    
    var body: some View {
        ZStack {
            CircularProgressView(
                progress: progress,
                lineWidth: lineWidth,
                color: color
            )
            
            content()
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        CircularProgressView(progress: 0.7, lineWidth: 12, color: .red)
            .frame(width: 150, height: 150)
        
        CircularProgressWithContent(progress: 0.5, color: .blue) {
            VStack {
                Text("25:00")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("专注中")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 200, height: 200)
    }
    .padding()
}