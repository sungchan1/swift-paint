//
//  DrawingPath.swift
//  Paint
//
//  Created by 여성찬 on 4/13/25.
//
import SwiftUI

struct DrawingPath: Identifiable {
    let id = UUID()
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
}
