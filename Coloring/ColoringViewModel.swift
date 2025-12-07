//
//  ColoringViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import Foundation
import SwiftUI
internal import Combine


@MainActor
class ColoringViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLetter: String = ""
    @Published var selectedColor: Color = .red
    @Published var coloredPaths: [ColoredPath] = []
    @Published var isCompleted: Bool = false
    @Published var showSuccessView: Bool = false
    
    // Available colors for coloring
    let availableColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .brown
    ]
    
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
    }
    
    func addPath(_ path: Path) {
        let coloredPath = ColoredPath(path: path, color: selectedColor)
        coloredPaths.append(coloredPath)
    }
    
    func clearColoring() {
        coloredPaths.removeAll()
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

// MARK: - Colored Path Model

struct ColoredPath: Identifiable {
    let id = UUID()
    let path: Path
    let color: Color
}
