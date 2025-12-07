//
//  Untitled.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI

// MARK: - Drawing Path Model
struct DrawingPath: Identifiable {
    let id = UUID()
    var points: [CGPoint]
    var color: Color
    var isEraser: Bool
    
    init(points: [CGPoint], color: Color, isEraser: Bool = false) {
        self.points = points
        self.color = color
        self.isEraser = isEraser
    }
}

// MARK: - Color Palette Model
struct ColorPalette {
    let name: String
    let assetName: String
    
    static let availableColors: [ColorPalette] = [
        ColorPalette(name: "Green", assetName: "ColorGreen"),
        ColorPalette(name: "Blue", assetName: "ColorBlue"),
        ColorPalette(name: "Pink", assetName: "ColorPink"),
        ColorPalette(name: "Red", assetName: "ColorRed"),
        ColorPalette(name: "Purple", assetName: "ColorPurple")
    ]
}

// MARK: - Drawing Constants
enum DrawingConstants {
    static let normalLineWidth: CGFloat = 8
    static let eraserLineWidth: CGFloat = 25
    static let buttonSize: CGFloat = 60
    static let colorCircleSize: CGFloat = 55
    static let eraserCircleSize: CGFloat = 65
    static let paletteWidth: CGFloat = 450
    static let paletteHeight: CGFloat = 120
}
