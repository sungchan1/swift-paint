import SwiftUI
struct ContentView: View {
    @Environment(\.undoManager) private var undoManager
    @StateObject private var viewModel = DrawingViewModel()
    @State private var selectedColor: Color = .black
    @State private var currentPoints: [CGPoint] = []

    let defaultColors: [Color] = [.black, .red, .blue, .green, .orange, .purple, .yellow, .gray]

    var body: some View {
        VStack {
            // 색상 선택
            HStack {
                ForEach(defaultColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            selectedColor = color
                        }
                        .overlay(
                            Circle()
                                .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 2)
                        )
                }
            }
            HStack {
                Button("Undo") {
                    viewModel.undo(using: undoManager)
                }
                .disabled(viewModel.paths.isEmpty)

                Button("Redo") {
                    viewModel.redo(using: undoManager)
                }
                .disabled(!viewModel.canRedo)
            }
            
            
            .padding()

            // 그림 영역
            ZStack {
                ForEach(viewModel.paths) { path in
                    Path { p in p.addLines(path.points) }
                        .stroke(path.color, lineWidth: 2)
                }

                Path { p in p.addLines(currentPoints) }
                    .stroke(selectedColor, lineWidth: 2)
            }
            .background(Color.white)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        currentPoints.append(value.location)
                    }
                    .onEnded { _ in
                        let newPath = DrawingPath(points: currentPoints, color: selectedColor, lineWidth: 2)
                        viewModel.addPath(newPath, using: undoManager)
                        currentPoints = []
                    }
            )
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
}
