import SwiftUI

struct CanvasView: View {
    @Binding var paths: [DrawingPath]
    let selectedColor: Color
    let lineWidth: CGFloat
    let onDrawingEnded: (DrawingPath) -> Void

    @State private var currentPoints: [CGPoint] = []

    var body: some View {
        ZStack {
            // 기존 경로 그리기
            ForEach(paths) { path in
                Path { p in p.addLines(path.points) }
                    .stroke(path.color, lineWidth: path.lineWidth)
            }

            // 현재 그리고 있는 선
            Path { p in p.addLines(currentPoints) }
                .stroke(selectedColor, lineWidth: lineWidth)
        }
        .background(Color.white)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    currentPoints.append(value.location)
                }
                .onEnded { _ in
                    let newPath = DrawingPath(points: currentPoints, color: selectedColor, lineWidth: lineWidth)
                    onDrawingEnded(newPath)
                    currentPoints = []
                }
        )
    }
}
