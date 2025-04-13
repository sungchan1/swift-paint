import SwiftUI
struct ContentView: View {
    @State private var paths: [DrawingPath] = []
    @State private var redoStack: [DrawingPath] = []
    @State private var selectedColor: Color = .black
    @State private var recentColors: [Color] = []
    @State private var lineWidth: CGFloat = 3.0

    let defaultColors: [Color] = [.black, .red, .blue, .green, .orange, .purple, .yellow, .gray]

    var body: some View {
        VStack(spacing: 10) {
            ColorPaletteView(
                defaultColors: defaultColors,
                recentColors: recentColors,
                onSelect: { color in
                    selectedColor = color
                    updateRecentColors(color)
                }
            )
            .padding(.top)

            HStack {
                Button("Undo") { undo() }
                Button("Redo") { redo() }
                Slider(value: $lineWidth, in: 1...10) {
                    Text("Line Width")
                }.frame(width: 150)
            }

            CanvasView(paths: $paths, selectedColor: selectedColor, lineWidth: lineWidth) { newPath in
                redoStack.removeAll()
            }
            .border(Color.gray)
        }
        .padding()
    }

    private func undo() {
        guard let last = paths.popLast() else { return }
        redoStack.append(last)
    }

    private func redo() {
        guard let last = redoStack.popLast() else { return }
        paths.append(last)
    }

    private func updateRecentColors(_ color: Color) {
        guard !defaultColors.contains(color) else { return }
        recentColors.removeAll { $0 == color }
        recentColors.insert(color, at: 0)
        if recentColors.count > 8 {
            recentColors = Array(recentColors.prefix(8))
        }
    }
}
