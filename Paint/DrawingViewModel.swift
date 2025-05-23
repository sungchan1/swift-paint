//
//  DrawingViewModel.swift
//  Paint
//
//  Created by 여성찬 on 4/13/25.
//

import SwiftUI

class DrawingViewModel: ObservableObject {
    @Published var paths: [DrawingPath] = []
    private var redoStack: [DrawingPath] = []

    func addPath(_ path: DrawingPath, using undoManager: UndoManager?) {
        paths.append(path)
        redoStack.removeAll()
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo(using: undoManager)
        }
    }

    func undo(using undoManager: UndoManager?) {
        guard let last = paths.popLast() else { return }
        redoStack.append(last)
        undoManager?.registerUndo(withTarget: self) { target in
            target.redo(using: undoManager)
        }
    }

    func redo(using undoManager: UndoManager?) {
        guard let last = redoStack.popLast() else { return }
        paths.append(last)
        undoManager?.registerUndo(withTarget: self) { target in
            target.undo(using: undoManager)
        }
    }

    func clear(using undoManager: UndoManager?) {
        let oldPaths = paths
        paths.removeAll()

        undoManager?.registerUndo(withTarget: self) { target in
            target.restore(oldPaths, using: undoManager)
        }
    }

    private func restore(_ savedPaths: [DrawingPath], using undoManager: UndoManager?) {
        let current = paths
        paths = savedPaths

        undoManager?.registerUndo(withTarget: self) { target in
            target.restore(current, using: undoManager)
        }
    }

    var canRedo: Bool {
        !redoStack.isEmpty
    }
}
