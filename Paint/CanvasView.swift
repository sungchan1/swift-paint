// CanvasView.swift
import SwiftUI

struct CanvasView: View {
    @Binding var paths: [DrawingPath]
    @State private var currentPoints: [CGPoint] = []

    var selectedColor: Color
    var lineWidth: CGFloat
    var onDrawEnd: ((DrawingPath) -> Void)?

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(paths) { path in
                    Path { p in p.addLines(path.points) }
                        .stroke(path.color, lineWidth: path.lineWidth)
                }
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
                        paths.append(newPath)
                        onDrawEnd?(newPath)
                        currentPoints = []
                    }
            )
        }
    }
}
