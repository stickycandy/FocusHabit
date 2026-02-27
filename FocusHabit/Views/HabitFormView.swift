//
//  HabitFormView.swift
//  FocusHabit
//
//  习惯创建/编辑表单视图
//

import SwiftUI
import SwiftData

/// 习惯表单视图
/// 用于创建新习惯或编辑现有习惯
struct HabitFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    /// 传入 nil 表示创建模式，传入 Habit 表示编辑模式
    let habit: Habit?
    
    // 表单状态
    @State private var name: String = ""
    @State private var icon: String = "star.fill"
    @State private var color: String = "#007AFF"
    @State private var targetCount: Int = 1
    
    // UI 状态
    @State private var showingDeleteAlert = false
    @State private var showingIconPicker = false
    
    /// 是否为编辑模式
    private var isEditing: Bool { habit != nil }
    
    /// 表单是否有效
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // 预览区域
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: icon)
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                                .frame(width: 80, height: 80)
                                .background(Color(hex: color))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text(name.isEmpty ? "习惯名称" : name)
                                .font(.headline)
                                .foregroundStyle(name.isEmpty ? .secondary : .primary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .listRowBackground(Color.clear)
                }
                
                // 名称输入
                Section("基本信息") {
                    TextField("习惯名称", text: $name)
                        .font(.body)
                    
                    Stepper("每日目标: \(targetCount) 次", value: $targetCount, in: 1...10)
                }
                
                // 图标选择
                Section {
                    DisclosureGroup(isExpanded: $showingIconPicker) {
                        IconPicker(selectedIcon: $icon, themeColor: Color(hex: color))
                            .padding(.vertical, 8)
                    } label: {
                        HStack {
                            Text("选择图标")
                            Spacer()
                            Image(systemName: icon)
                                .foregroundStyle(Color(hex: color))
                        }
                    }
                }
                
                // 颜色选择
                Section {
                    ThemeColorPicker(selectedColor: $color)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                
                // 删除按钮（仅编辑模式）
                if isEditing {
                    Section {
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            HStack {
                                Spacer()
                                Label("删除习惯", systemImage: "trash")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "编辑习惯" : "新建习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
            .alert("删除习惯", isPresented: $showingDeleteAlert) {
                Button("取消", role: .cancel) {}
                Button("删除", role: .destructive) {
                    delete()
                }
            } message: {
                Text("删除后，该习惯的所有打卡记录也将被删除。此操作无法撤销。")
            }
            .onAppear {
                loadHabitData()
            }
        }
    }
    
    /// 加载习惯数据（编辑模式）
    private func loadHabitData() {
        guard let habit = habit else { return }
        name = habit.name
        icon = habit.icon
        color = habit.color
        targetCount = habit.targetCount
    }
    
    /// 保存习惯
    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let habit = habit {
            // 编辑模式：更新现有习惯
            habit.name = trimmedName
            habit.icon = icon
            habit.color = color
            habit.targetCount = targetCount
        } else {
            // 创建模式：新建习惯
            let newHabit = Habit(
                name: trimmedName,
                icon: icon,
                color: color,
                targetCount: targetCount
            )
            modelContext.insert(newHabit)
        }
        
        dismiss()
    }
    
    /// 删除习惯
    private func delete() {
        guard let habit = habit else { return }
        modelContext.delete(habit)
        dismiss()
    }
}

#Preview("创建模式") {
    HabitFormView(habit: nil)
        .modelContainer(for: [Habit.self, HabitLog.self], inMemory: true)
}

#Preview("编辑模式") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, HabitLog.self, configurations: config)
    
    let habit = Habit(name: "阅读", icon: "book.fill", color: "#34C759")
    container.mainContext.insert(habit)
    
    return HabitFormView(habit: habit)
        .modelContainer(container)
}