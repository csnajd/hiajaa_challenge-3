//
//  ColoringViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI
internal import Combine

class ColoringViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLetter: String = ""
    @Published var selectedColor: Color = .green
    @Published var isErasing: Bool = false
    @Published var drawingPaths: [DrawingPath] = []
    @Published var currentPath: [CGPoint] = []
    @Published var isCompleted: Bool = false
    @Published var showSuccessView: Bool = false
    
    // For heavy pen effect - the drawn point "chases" the finger
    private var targetPoint: CGPoint?
    private var currentDrawPoint: CGPoint?
    private var timer: Timer?
    private let chaseSpeed: CGFloat = 0.12  // Lower = heavier/slower (0.05 to 0.3)
    
    // Use the static availableColors from ColorPalette
    var availableColors: [ColorPalette] {
        ColorPalette.availableColors
    }
    
    // All available Arabic letters for navigation
    private let allLetters = [
        "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
        "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
        "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
        "ن", "هـ", "و", "ي"
    ]
    
    // MARK: - Initialization
    init() {}
    
    init(selectedLetter: String) {
        self.selectedLetter = selectedLetter
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            self?.updateDrawing()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateDrawing() {
        guard let target = targetPoint else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let current = self.currentDrawPoint {
                // Interpolate towards target (creates the heavy/lagging effect)
                let newX = current.x + (target.x - current.x) * self.chaseSpeed
                let newY = current.y + (target.y - current.y) * self.chaseSpeed
                let newPoint = CGPoint(x: newX, y: newY)
                
                // Only add point if moved enough
                let distance = hypot(newPoint.x - current.x, newPoint.y - current.y)
                if distance > 0.5 {
                    self.currentDrawPoint = newPoint
                    self.currentPath.append(newPoint)
                }
            } else {
                self.currentDrawPoint = target
                self.currentPath.append(target)
            }
        }
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
        targetPoint = point
        
        // Start timer if not running
        if timer == nil {
            currentDrawPoint = point
            currentPath.append(point)
            startTimer()
        }
    }
    
    func finishDrawing() {
        // Stop the timer
        stopTimer()
        
        // Catch up to final target
        if let target = targetPoint, let current = currentDrawPoint {
            var point = current
            for _ in 0..<15 {
                let newX = point.x + (target.x - point.x) * 0.25
                let newY = point.y + (target.y - point.y) * 0.25
                point = CGPoint(x: newX, y: newY)
                currentPath.append(point)
            }
            currentPath.append(target)
        }
        
        if !currentPath.isEmpty {
            let newPath = DrawingPath(
                points: currentPath,
                color: isErasing ? .white : selectedColor,
                isEraser: isErasing
            )
            drawingPaths.append(newPath)
            currentPath = []
        }
        
        targetPoint = nil
        currentDrawPoint = nil
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
        stopTimer()
        drawingPaths.removeAll()
        currentPath = []
        isCompleted = false
        showSuccessView = false
        targetPoint = nil
        currentDrawPoint = nil
    }
    
    func markAsComplete() {
        isCompleted = true
        
        // Show success view after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showSuccessView = true
        }
    }
    
    func nextLetter() {
        guard let currentIndex = allLetters.firstIndex(of: selectedLetter) else {
            selectedLetter = "أ"
            clearColoring()
            return
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        selectedLetter = allLetters[nextIndex]
        clearColoring()
    }
    
    func getCurrentLetterIndex() -> Int {
        return allLetters.firstIndex(of: selectedLetter) ?? 0
    }
}
