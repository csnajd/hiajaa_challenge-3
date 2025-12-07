//
//  ColoringViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import Foundation
import SwiftUI
internal import Combine

class ColoringViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedColor: Color = Color("ColorGreen")
    @Published var drawingPaths: [DrawingPath] = []
    @Published var currentPath: [CGPoint] = []
    @Published var isErasing: Bool = false
    
    // MARK: - Properties
    let availableColors = ColorPalette.availableColors
    
    // MARK: - Drawing Methods
    func addPoint(_ point: CGPoint) {
        currentPath.append(point)
    }
    
    func finishDrawing() {
        guard !currentPath.isEmpty else { return }
        
        let newPath = DrawingPath(
            points: currentPath,
            color: isErasing ? .white : selectedColor,
            isEraser: isErasing
        )
        
        drawingPaths.append(newPath)
        currentPath = []
    }
    
    // MARK: - Color Selection Methods
    func selectColor(_ color: Color) {
        selectedColor = color
        isErasing = false
    }
    
    func selectEraser() {
        isErasing = true
    }
    
    func isColorSelected(_ color: Color) -> Bool {
        return !isErasing && selectedColor == color
    }
    
    // MARK: - Canvas Methods
    func getLineWidth(for path: DrawingPath) -> CGFloat {
        return path.isEraser ? DrawingConstants.eraserLineWidth : DrawingConstants.normalLineWidth
    }
    
    func getCurrentLineWidth() -> CGFloat {
        return isErasing ? DrawingConstants.eraserLineWidth : DrawingConstants.normalLineWidth
    }
    
    func getCurrentColor() -> Color {
        return isErasing ? .white : selectedColor
    }
    
    // MARK: - Clear Methods
    func clearAll() {
        drawingPaths.removeAll()
        currentPath.removeAll()
    }
}
