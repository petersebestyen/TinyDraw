//
//  Drawing.swift
//  TinyDraw
//
//  Created by Péter Sebestyén on 2024.09.21.
//

import SwiftUI

class Drawing: ObservableObject {
    // All strokes we draw already
    private var oldStorkes = [Stroke]()
    
    // The current stroek being drawn
    private var currentStroke = Stroke()
    
    // A computed property combining previous strokes with the new one
    var strokes: [Stroke] {
        var all = oldStorkes
        all.append(currentStroke)
        return all
    }
    
    // An empty, default init, userful for later when we add a second, more complex one
    init() { }
    
    // Adds to the existing strokes
    func add(point: CGPoint) {
        objectWillChange.send()
        currentStroke.points.append(point)
    }
    
    // Called when the user lifts their brush
    func finishedStroke() {
        objectWillChange.send()
        oldStorkes.append(currentStroke)
        newStroke()
    }
    
    // Starts a refresh stroke with defautl options
    func newStroke() {
        currentStroke = Stroke(color: foregroundColor, width: lineWidth, spacing: lineSpacing, blur: blurAmount)
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
}

