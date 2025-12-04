//
//  WordpuzzleViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 04/12/2025.
//
import SwiftUI
internal import Combine

@MainActor
class WordPuzzleViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLetter: String = ""
    @Published var currentWord: String = ""
    @Published var currentPuzzle: WordPuzzleModel?
    @Published var letters: [Letter] = []
    @Published var targetSlots: [Letter?] = []
    @Published var isCompleted: Bool = false
    @Published var shakingLetterId: UUID?
    @Published var showSuccessAnimation: Bool = false
    
    // MARK: - Private Properties
    private let letterColors: [Color] = [
        Color(red: 1.0, green: 0.6, blue: 0.6),      // Light red
        Color(red: 0.6, green: 1.0, blue: 0.6),      // Light green
        Color(red: 0.6, green: 0.6, blue: 1.0),      // Light blue
        Color(red: 1.0, green: 1.0, blue: 0.6),      // Light yellow
        Color(red: 1.0, green: 0.8, blue: 0.6),      // Light orange
        Color(red: 0.9, green: 0.6, blue: 1.0)       // Light purple
    ]
    
    // MARK: - Initialization
    init() {}
    
    /// Initialize with a selected letter
    init(selectedLetter: String) {
        self.selectLetter(selectedLetter)
    }
    
    // MARK: - Public Methods
    
    /// Get words that start with a specific letter
    func getWords(startingWith letter: String) -> [WordPuzzleModel] {
        return allWords.filter { $0.word.lowercased().hasPrefix(letter.lowercased()) }
    }
    
    /// Select a letter and load a random word starting with that letter
    func selectLetter(_ letter: String) {
        selectedLetter = letter.uppercased()
        loadRandomWord(startingWith: selectedLetter)
    }
    
    /// Load a random word starting with the selected letter
    private func loadRandomWord(startingWith letter: String) {
        let words = getWords(startingWith: letter)
        
        guard let randomWord = words.randomElement() else {
            // Fallback if no words found - pick any random word
            currentPuzzle = allWords.randomElement()
            currentWord = currentPuzzle?.word.lowercased() ?? "lion"
            setupPuzzle()
            return
        }
        
        currentPuzzle = randomWord
        currentWord = randomWord.word.lowercased()
        setupPuzzle()
    }
    
    /// Setup the puzzle by creating shuffled letters
    private func setupPuzzle() {
        isCompleted = false
        showSuccessAnimation = false
        
        // Create letter objects with colors
        letters = currentWord.enumerated().map { index, char in
            Letter(
                character: String(char).uppercased(),
                correctPosition: index,
                currentPosition: nil,
                isPlaced: false,
                color: letterColors[index % letterColors.count]
            )
        }
        
        // Shuffle letters for the draggable area
        letters.shuffle()
        
        // Initialize empty target slots
        targetSlots = Array(repeating: nil, count: currentWord.count)
    }
    
    /// Handle letter drop in a target slot
    func dropLetter(_ letter: Letter, at position: Int) {
        guard let letterIndex = letters.firstIndex(where: { $0.id == letter.id }) else {
            return
        }
        
        // Check if slot is already occupied
        if targetSlots[position] != nil {
            // Shake the letter and return it
            shakeAndReturn(letter)
            return
        }
        
        // Check if letter is correct for this position
        if letter.correctPosition == position {
            // Correct placement
            var updatedLetter = letter
            updatedLetter.currentPosition = position
            updatedLetter.isPlaced = true
            
            letters[letterIndex] = updatedLetter
            targetSlots[position] = updatedLetter
            
            checkCompletion()
        } else {
            // Wrong placement - shake and return
            shakeAndReturn(letter)
        }
    }
    
    /// Remove letter from target slot
    func removeLetter(at position: Int) {
        guard let letter = targetSlots[position],
              let letterIndex = letters.firstIndex(where: { $0.id == letter.id }) else {
            return
        }
        
        var updatedLetter = letter
        updatedLetter.currentPosition = nil
        updatedLetter.isPlaced = false
        
        letters[letterIndex] = updatedLetter
        targetSlots[position] = nil
    }
    
    /// Shake animation for wrong placement
    private func shakeAndReturn(_ letter: Letter) {
        shakingLetterId = letter.id
        
        // Reset shaking after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.shakingLetterId = nil
        }
    }
    
    /// Check if puzzle is completed
    private func checkCompletion() {
        let allPlaced = targetSlots.allSatisfy { $0 != nil }
        
        if allPlaced {
            isCompleted = true
            showSuccessAnimation = true
        }
    }
    
    /// Reset the current puzzle
    func resetPuzzle() {
        setupPuzzle()
    }
    
    /// Move to next word
    func nextWord() {
        loadRandomWord(startingWith: selectedLetter)
    }
    
    // MARK: - Helper Methods
    
    /// Get available (not placed) letters
    func getAvailableLetters() -> [Letter] {
        return letters.filter { !$0.isPlaced }
    }
    
    
    func getLetterAt(position: Int) -> Letter? {
        return targetSlots[position]
    }
    
    
    func isLetterShaking(_ letter: Letter) -> Bool {
        return shakingLetterId == letter.id
    }
}
