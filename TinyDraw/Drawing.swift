//
//  Drawing.swift
//  TinyDraw
//
//  Created by Péter Sebestyén on 2024.09.21.
//

import SwiftUI

class Drawing: ObservableObject {
    // All strokes we draw already
    private var oldStrokes = [Stroke]()
    
    // The current stroek being drawn
    private var currentStroke = Stroke()
    
    // A computed property combining previous strokes with the new one
    var strokes: [Stroke] {
        var all = oldStrokes
        all.append(currentStroke)
        return all
    }
    
    // Stroke object values exposed in here
    @Published var foregroundColor: Color = .black {
        didSet {
            currentStroke.color = foregroundColor
        }
    }
    
    @Published var lineWidth = 3.0 {
        didSet {
            currentStroke.width = lineWidth
        }
    }

    @Published var lineSpacing = 0.0 {
        didSet {
            currentStroke.spacing = lineSpacing
        }
    }
    
    @Published var blurAmount = 0.0 {
        didSet {
            currentStroke.blur = blurAmount
        }
    }

    var undoManager: UndoManager?
        
    // An empty, default init, userful for later when we add a second, more complex one
    init() { }
    
    // Adds to the existing strokes
    func add(point: CGPoint) {
        objectWillChange.send()
        currentStroke.points.append(point)
    }
    
    // Called when the user lifts their brush
    func finishedStroke() {
        addStrokeWithUndo(currentStroke)
    }
    
    // Starts a refresh stroke with defautl options
    func newStroke() {
        currentStroke = Stroke(color: foregroundColor, width: lineWidth, spacing: lineSpacing, blur: blurAmount)
    }
    
    func undo() {
        objectWillChange.send()
        undoManager?.undo()
    }
    
    func redo() {
        objectWillChange.send()
        undoManager?.redo()
    }
    
    /*
    Just to be clear, I want you to follow through the execution when an undo happens:

    1. We immediately run the undo action that was prepared, which calls removeStrokeWithUndo().
    2. Before we remove the stroke, we create a new undo action that calls addStrokeWithUndo().
    3. However, because we’re in the middle of an undo operation right now, iOS recognizes that new undo action as being a redo
       – we’re adding an undo action to undo whatever other undo action is currently in flight.
    */
    
    private func addStrokeWithUndo(_ stroke: Stroke) {
        undoManager?.registerUndo(withTarget: self) { drawing in
            drawing.removeStrokeWithUndo(stroke)
        }
        
        objectWillChange.send()
        oldStrokes.append(stroke)
        newStroke()
    }
    
    private func removeStrokeWithUndo(_ stroke: Stroke) {
        undoManager?.registerUndo(withTarget: self) { drawing in
            drawing.addStrokeWithUndo(stroke)
        }
        oldStrokes.removeLast()
    }
}

