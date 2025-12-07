//
//  ColoringViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI
internal import Combine


@MainActor
class ColoringViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLetter: String = ""
    @Published var selectedColor: Color = .green
    @Published var isErasing: Bool = false
    @Published var drawingPaths: [DrawingPath] = []
    @Published var currentPath: [CGPoint] = []
    @Published var isCompleted: Bool = false
    @Published var showSuccessView: Bool = false
    
    // Use the static availableColors from ColorPalette
    var availableColors: [ColorPalette] {
        ColorPalette.availableColors
    }
    
    // All available letters for navigation
    private let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H",
                              "I", "J", "K", "L", "M", "N", "O", "P",
                              "Q", "R", "S", "T", "U", "V", "W", "X",
                              "Y", "Z"]
    
    // MARK: - Initialization
    init() {}
    
    init(selectedLetter: String) {
        self.selectedLetter = selectedLetter.uppercased()
    }
    
    // MARK: - Public Methods
    
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
    
    func addPoint(_ point: CGPoint) {
        currentPath.append(point)
    }
    
    func finishDrawing() {
        if !currentPath.isEmpty {
            let newPath = DrawingPath(
                points: currentPath,
                color: isErasing ? .white : selectedColor,
                isEraser: isErasing
            )
            drawingPaths.append(newPath)
            currentPath = []
        }
    }
    
    func getCurrentColor() -> Color {
        return isErasing ? .white : selectedColor
    }
    
    func getCurrentLineWidth() -> CGFloat {
        return isErasing ? DrawingConstants.eraserLineWidth : DrawingConstants.normalLineWidth
    }
    
    func getLineWidth(for path: DrawingPath) -> CGFloat {
        return path.isEraser ? DrawingConstants.eraserLineWidth : DrawingConstants.normalLineWidth
    }
    
    func clearColoring() {
        drawingPaths.removeAll()
        currentPath = []
        isCompleted = false
        showSuccessView = false
    }
    
    func markAsComplete() {
        isCompleted = true
        
        // Show success view after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showSuccessView = true
        }
    }
    
    func nextLetter() {
        guard let currentIndex = allLetters.firstIndex(of: selectedLetter.uppercased()) else {
            selectedLetter = "A"
            clearColoring()
            return
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        selectedLetter = allLetters[nextIndex]
        clearColoring()
    }
    
    func getCurrentLetterIndex() -> Int {
        return allLetters.firstIndex(of: selectedLetter.uppercased()) ?? 0
    }
}
