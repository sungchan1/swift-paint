//
//  ColorPaletteView.swift
//  Paint
//
//  Created by 여성찬 on 4/13/25.
//

// ColorPaletteView.swift
import SwiftUI

struct ColorPaletteView: View {
    let defaultColors: [Color]
    var recentColors: [Color]
    var onSelect: (Color) -> Void

    var body: some View {
        HStack {
            ForEach(defaultColors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 24, height: 24)
                    .onTapGesture { onSelect(color) }
            }
            Divider().frame(height: 30)
            ForEach(recentColors, id: \.self) { color in
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .background(Circle().fill(color))
                    .frame(width: 24, height: 24)
                    .onTapGesture { onSelect(color) }
            }
        }
    }
}
