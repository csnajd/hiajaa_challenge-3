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
    
    // Letter outline path for boundary detection
    private var letterOutlinePath: CGPath?
    private let protectedStrokeWidth: CGFloat = 6.0  // Increased for better protection
    
    // For heavy pen effect
    private var targetPoint: CGPoint?
    private var currentDrawPoint: CGPoint?
    private var timer: Timer?
    private let chaseSpeed: CGFloat = 0.12
    
    var availableColors: [ColorPalette] {
        ColorPalette.availableColors
    }
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.generateLetterOutlinePath()
        }
    }
    
    // Generate the letter outline path for hit detection
    func generateLetterOutlinePath(canvasSize: CGSize = CGSize(width: 400, height: 500)) {
        let fontSize: CGFloat = 350
        let font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: selectedLetter, attributes: attributes)
        let line = CTLineCreateWithAttributedString(attributedString)
        
        guard let runs = CTLineGetGlyphRuns(line) as? [CTRun], let run = runs.first else {
            return
        }
        
        let glyphCount = CTRunGetGlyphCount(run)
        var glyphs = [CGGlyph](repeating: 0, count: glyphCount)
        var positions = [CGPoint](repeating: .zero, count: glyphCount)
        
        CTRunGetGlyphs(run, CFRangeMake(0, glyphCount), &glyphs)
        CTRunGetPositions(run, CFRangeMake(0, glyphCount), &positions)
        
        let path = CGMutablePath()
        for i in 0..<glyphCount {
            if let glyphPath = CTFontCreatePathForGlyph(font, glyphs[i], nil) {
                let transform = CGAffineTransform(translationX: positions[i].x, y: positions[i].y)
                path.addPath(glyphPath, transform: transform)
            }
        }
        
        // Center the path
        let pathBounds = path.boundingBox
        let offsetX = (canvasSize.width - pathBounds.width) / 2 - pathBounds.minX
        let offsetY = (canvasSize.height - pathBounds.height) / 2 - pathBounds.minY
        
        var transform = CGAffineTransform(translationX: offsetX, y: offsetY)
        if let centeredPath = path.copy(using: &transform) {
            letterOutlinePath = centeredPath
        }
    }
    
    // Check if point is on the letter outline (protected area)
    private func isPointOnLetterOutline(_ point: CGPoint) -> Bool {
        guard let path = letterOutlinePath else { return false }
        
        // Create stroked path with tolerance
        let strokedPath = path.copy(strokingWithWidth: protectedStrokeWidth, lineCap: .round, lineJoin: .round, miterLimit: 0)
        
        return strokedPath.contains(point)
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
                let newX = current.x + (target.x - current.x) * self.chaseSpeed
                let newY = current.y + (target.y - current.y) * self.chaseSpeed
                let newPoint = CGPoint(x: newX, y: newY)
                
                let distance = hypot(newPoint.x - current.x, newPoint.y - current.y)
                if distance > 0.5 {
                    self.currentDrawPoint = newPoint
                    // Check if new point is protected before adding
                    if !self.isPointOnLetterOutline(newPoint) {
                        self.currentPath.append(newPoint)
                    }
                }
            } else {
                self.currentDrawPoint = target
                if !self.isPointOnLetterOutline(target) {
                    self.currentPath.append(target)
                }
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
    
    func addPoint(_ point: CGPoint, canvasSize: CGSize = CGSize(width: 400, height: 500)) {
        // Skip if point is on protected letter outline
        if isPointOnLetterOutline(point) {
            return
        }
        
        targetPoint = point
        
        if timer == nil {
            currentDrawPoint = point
            if !isPointOnLetterOutline(point) {
                currentPath.append(point)
            }
            startTimer()
        }
    }
    
    func finishDrawing() {
        stopTimer()
        
        if let target = targetPoint, let current = currentDrawPoint {
            var point = current
            for _ in 0..<15 {
                let newX = point.x + (target.x - point.x) * 0.25
                let newY = point.y + (target.y - point.y) * 0.25
                point = CGPoint(x: newX, y: newY)
                if !isPointOnLetterOutline(point) {
                    currentPath.append(point)
                }
            }
            if !isPointOnLetterOutline(target) {
                currentPath.append(target)
            }
        }
        
        if !currentPath.isEmpty {
            if isErasing {
                // Erase mode: remove parts of paths that intersect
                erasePathSegmentsIntersectingWith(currentPath)
            } else {
                // Draw mode: add new path
                let newPath = DrawingPath(
                    points: currentPath,
                    color: selectedColor,
                    isEraser: false
                )
                drawingPaths.append(newPath)
            }
            currentPath = []
        }
        
        targetPoint = nil
        currentDrawPoint = nil
    }
    
    // Erase specific segments of paths that intersect with eraser stroke
    private func erasePathSegmentsIntersectingWith(_ eraserPoints: [CGPoint]) {
        let eraserRadius = DrawingConstants.eraserLineWidth / 2
        var newPaths: [DrawingPath] = []
        
        for path in drawingPaths {
            var currentSegment: [CGPoint] = []
            
            for point in path.points {
                var shouldErase = false
                
                // Check if this point intersects with any eraser point
                for eraserPoint in eraserPoints {
                    let distance = hypot(point.x - eraserPoint.x, point.y - eraserPoint.y)
                    if distance <= eraserRadius {
                        shouldErase = true
                        break
                    }
                }
                
                if shouldErase {
                    // Save current segment if it has enough points
                    if currentSegment.count > 3 {
                        let newPath = DrawingPath(
                            points: currentSegment,
                            color: path.color,
                            isEraser: false
                        )
                        newPaths.append(newPath)
                    }
                    currentSegment = []
                } else {
                    currentSegment.append(point)
                }
            }
            
            // Add remaining segment
            if currentSegment.count > 3 {
                let newPath = DrawingPath(
                    points: currentSegment,
                    color: path.color,
                    isEraser: false
                )
                newPaths.append(newPath)
            }
        }
        
        drawingPaths = newPaths
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
