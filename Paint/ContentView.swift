import SwiftUI

struct ContentView: View {
    @Environment(\.undoManager) private var undoManager
    @StateObject private var viewModel = DrawingViewModel()
    @State private var selectedColor: Color = .black
    @State private var recentColors: [Color] = []

    private var canvasSection: some View {
        CanvasView(
            paths: $viewModel.paths,
            selectedColor: selectedColor,
            lineWidth: 2,
            onDrawingEnded: { newPath in
                viewModel.addPath(newPath, using: undoManager)
                updateRecentColors(selectedColor)
            }
        )
        .border(Color.gray)
    }

    let defaultColors: [Color] = [.black, .red, .blue, .green, .orange, .purple, .yellow, .gray]

    var body: some View {
        VStack {
            // 🎨 색상 선택 (기본 + 최근 + 컬러피커)
            HStack(spacing: 8) {
                // 기본 색상
                ForEach(defaultColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            selectedColor = color
                        }
                        .overlay(
                            Circle()
                                .stroke(selectedColor == color ? Color.primary : .clear, lineWidth: 2)
                        )
                }

                Divider().frame(height: 24)

                // 최근 색상
                ForEach(0 ..< 8, id: \.self) { index in

                    let color = index < recentColors.count ? recentColors[index] : nil

                    Circle()
                        .fill(color ?? Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Group {
                                if let color = color {
                                    Circle().stroke(selectedColor == color ? Color.primary : .gray, lineWidth: 1)
                                } else {
                                    Circle().stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [2]))
                                }
                            }
                        )
                        .onTapGesture {
                            if let color = color {
                                selectedColor = color
                            }
                        }
                }

                // 컬러 피커
                ColorPicker("", selection: $selectedColor, supportsOpacity: true)
                    .labelsHidden()
                    .frame(width: 24, height: 24)
                    .onChange(of: selectedColor) {
                        updateRecentColors($0)
                    }
            }
            .padding()

            // ↩️ Undo / Redo 버튼
            HStack {
                Button("Undo") {
                    viewModel.undo(using: undoManager)
                }
                .disabled(viewModel.paths.isEmpty)

                Button("Redo") {
                    viewModel.redo(using: undoManager)
                }
                .disabled(!viewModel.canRedo)
                Button("Clear") {
                    viewModel.clear(using: undoManager)
                }
                .disabled(viewModel.paths.isEmpty)
            }
            .padding(.bottom)

            // 🎨 캔버스 뷰
            canvasSection
                .border(Color.gray)
        }
        .padding()
        .frame(minWidth: 600, minHeight: 500)
        .focusable()
        .onAppear {
            undoManager?.registerUndo(withTarget: viewModel) { _ in }
        }
        .onCommand(#selector(UndoManager.undo)) {
            viewModel.undo(using: undoManager)
        }
        .onCommand(#selector(UndoManager.redo)) {
            viewModel.redo(using: undoManager)
        }
    }

    private func updateRecentColors(_ color: Color) {
        guard !defaultColors.contains(color) else { return }
        if let first = recentColors.first, first == color { return }
        recentColors.removeAll { $0 == color }
        recentColors.insert(color, at: 0)
        if recentColors.count > 8 {
            recentColors = Array(recentColors.prefix(8))
        }
    }
}
