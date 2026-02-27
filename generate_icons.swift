#!/usr/bin/env swift

import AppKit
import Foundation

// App Icon View Generator
// Generates Light, Dark, and Tinted icons for iOS app at exact 1024x1024 pixels

let size: CGFloat = 1024
let cornerRadius = size * 0.2237

// Colors
let lightColors = (
    start: NSColor(red: 0.4, green: 0.85, blue: 0.55, alpha: 1.0),  // #66D98C
    end: NSColor(red: 0.0, green: 0.6, blue: 0.4, alpha: 1.0)       // #009966
)
let darkColors = (
    start: NSColor(red: 0.2, green: 0.55, blue: 0.35, alpha: 1.0),  // #338C59
    end: NSColor(red: 0.0, green: 0.35, blue: 0.22, alpha: 1.0)     // #005938
)

func createBitmapContext() -> NSBitmapImageRep {
    return NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size),
        pixelsHigh: Int(size),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
}

func drawIconContent(isDarkMode: Bool) {
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    
    // Background gradient
    let colors = isDarkMode ? darkColors : lightColors
    let gradient = NSGradient(starting: colors.start, ending: colors.end)
    gradient?.draw(in: path, angle: -45)
    
    // Center circle
    let circleSize = size * 0.65
    let circleX = (size - circleSize) / 2
    let circleY = (size - circleSize) / 2
    let circleRect = NSRect(x: circleX, y: circleY, width: circleSize, height: circleSize)
    let circlePath = NSBezierPath(ovalIn: circleRect)
    
    NSColor.white.withAlphaComponent(0.25).setFill()
    circlePath.fill()
    
    // Checkmark
    let checkPath = NSBezierPath()
    let checkCenterX = size / 2
    let checkCenterY = size / 2
    let checkScale = size * 0.18
    
    let startX = checkCenterX - checkScale * 0.9
    let startY = checkCenterY - checkScale * 0.1
    let midX = checkCenterX - checkScale * 0.2
    let midY = checkCenterY - checkScale * 0.7
    let endX = checkCenterX + checkScale * 1.1
    let endY = checkCenterY + checkScale * 0.8
    
    checkPath.move(to: NSPoint(x: startX, y: startY))
    checkPath.line(to: NSPoint(x: midX, y: midY))
    checkPath.line(to: NSPoint(x: endX, y: endY))
    
    checkPath.lineWidth = size * 0.08
    checkPath.lineCapStyle = .round
    checkPath.lineJoinStyle = .round
    NSColor.white.setStroke()
    checkPath.stroke()
}

func drawTintedContent() {
    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    
    // Solid gray background for tinted mode
    NSColor(white: 0.15, alpha: 1.0).setFill()
    path.fill()
    
    // Center circle with lighter gray
    let circleSize = size * 0.65
    let circleX = (size - circleSize) / 2
    let circleY = (size - circleSize) / 2
    let circleRect = NSRect(x: circleX, y: circleY, width: circleSize, height: circleSize)
    let circlePath = NSBezierPath(ovalIn: circleRect)
    
    NSColor.white.withAlphaComponent(0.15).setFill()
    circlePath.fill()
    
    // Checkmark in white
    let checkPath = NSBezierPath()
    let checkCenterX = size / 2
    let checkCenterY = size / 2
    let checkScale = size * 0.18
    
    let startX = checkCenterX - checkScale * 0.9
    let startY = checkCenterY - checkScale * 0.1
    let midX = checkCenterX - checkScale * 0.2
    let midY = checkCenterY - checkScale * 0.7
    let endX = checkCenterX + checkScale * 1.1
    let endY = checkCenterY + checkScale * 0.8
    
    checkPath.move(to: NSPoint(x: startX, y: startY))
    checkPath.line(to: NSPoint(x: midX, y: midY))
    checkPath.line(to: NSPoint(x: endX, y: endY))
    
    checkPath.lineWidth = size * 0.08
    checkPath.lineCapStyle = .round
    checkPath.lineJoinStyle = .round
    NSColor.white.setStroke()
    checkPath.stroke()
}

func createAppIcon(isDarkMode: Bool) -> NSBitmapImageRep {
    let bitmapRep = createBitmapContext()
    
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
    
    drawIconContent(isDarkMode: isDarkMode)
    
    NSGraphicsContext.restoreGraphicsState()
    
    return bitmapRep
}

func createTintedIcon() -> NSBitmapImageRep {
    let bitmapRep = createBitmapContext()
    
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
    
    drawTintedContent()
    
    NSGraphicsContext.restoreGraphicsState()
    
    return bitmapRep
}

func saveBitmap(_ bitmapRep: NSBitmapImageRep, to path: String) {
    guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
        print("❌ Failed to create PNG data for \(path)")
        return
    }
    
    do {
        try pngData.write(to: URL(fileURLWithPath: path))
        print("✅ Saved: \(path) (\(bitmapRep.pixelsWide)x\(bitmapRep.pixelsHigh))")
    } catch {
        print("❌ Error saving \(path): \(error)")
    }
}

// Generate and save icons
let basePath = FileManager.default.currentDirectoryPath
let iconsetPath = "\(basePath)/FocusHabit/Assets.xcassets/AppIcon.appiconset"

print("🎨 Generating FocusHabit App Icons...")
print("Output directory: \(iconsetPath)")

// Light icon
let lightIcon = createAppIcon(isDarkMode: false)
saveBitmap(lightIcon, to: "\(iconsetPath)/AppIcon-Light.png")

// Dark icon
let darkIcon = createAppIcon(isDarkMode: true)
saveBitmap(darkIcon, to: "\(iconsetPath)/AppIcon-Dark.png")

// Tinted icon
let tintedIcon = createTintedIcon()
saveBitmap(tintedIcon, to: "\(iconsetPath)/AppIcon-Tinted.png")

print("🎉 Done! All icons generated successfully.")