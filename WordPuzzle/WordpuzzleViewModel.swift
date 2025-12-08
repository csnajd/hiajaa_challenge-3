import SwiftUI
internal import Combine




@MainActor
class WordViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLetter: String = ""
    @Published var currentWord: String = ""
    @Published var currentPuzzle: WordModel?
    @Published var letters: [Letter] = []
    @Published var targetSlots: [Letter?] = []
    @Published var isCompleted: Bool = false
    @Published var shakingLetterId: UUID?
    @Published var showSuccessAnimation: Bool = false
    @Published var showSuccessView: Bool = false
    
    // Shakes the whole page on error
    @Published var shakePage: Bool = false
    
    // MARK: - Private Properties
    private let letterColors: [Color] = [
        Color(red: 1.0, green: 0.6, blue: 0.6),      // Light red
        Color(red: 0.6, green: 1.0, blue: 0.6),      // Light green
        Color(red: 0.6, green: 0.6, blue: 1.0),      // Light blue
        Color(red: 1.0, green: 1.0, blue: 0.6),      // Light yellow
        Color(red: 1.0, green: 0.8, blue: 0.6),      // Light orange
        Color(red: 0.9, green: 0.6, blue: 1.0)       // Light purple
    ]
    
    // All available Arabic letters for navigation
    private let allLetters = [
        "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
        "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
        "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
        "ن", "هـ", "و", "ي"
    ]
    
    // MARK: - Initialization
    init() {}
    
    /// Initialize with a selected letter
    init(selectedLetter: String) {
        self.selectLetter(selectedLetter)
    }
    
    // MARK: - Public Methods
    
    /// Get words that start with a specific Arabic letter
    func getWords(startingWith letter: String) -> [WordModel] {
        return allWords.filter { $0.startLetter == letter }
    }
    
    /// Select a letter and load a random word starting with that letter
    func selectLetter(_ letter: String) {
        selectedLetter = letter
        loadRandomWord(startingWith: selectedLetter)
    }
    
    /// Load a random word starting with the selected letter
    private func loadRandomWord(startingWith letter: String) {
        let words = getWords(startingWith: letter)
        
        guard let randomWord = words.randomElement() else {
            // Fallback if no words found - pick any random word
            currentPuzzle = allWords.randomElement()
            currentWord = currentPuzzle?.word ?? "أسد"
            setupPuzzle()
            return
        }
        
        currentPuzzle = randomWord
        currentWord = randomWord.word
        setupPuzzle()
    }
    
    /// Setup the puzzle by creating shuffled letters
    private func setupPuzzle() {
        isCompleted = false
        showSuccessAnimation = false
        showSuccessView = false
        
        let wordLength = currentWord.count
        
        // Create letter objects with colors
        // For Arabic RTL: position 0 is rightmost (first letter), position n-1 is leftmost (last letter)
        letters = currentWord.enumerated().map { index, char in
            Letter(
                character: String(char),
                correctPosition: index,  // Keep original position (0 = first letter = rightmost in RTL display)
                currentPosition: nil,
                isPlaced: false,
                color: letterColors[index % letterColors.count]
            )
        }
        
        // Shuffle letters for the draggable area
        letters.shuffle()
        
        // Initialize empty target slots
        targetSlots = Array(repeating: nil, count: wordLength)
    }
    
    /// Handle letter drop in a target slot
    func dropLetter(_ letter: Letter, at position: Int) {
        guard let letterIndex = letters.firstIndex(where: { $0.id == letter.id }) else {
            return
        }
        
        // If slot is already occupied, shake and return
        if targetSlots[position] != nil {
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
            // Wrong placement - shake page and return letter
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
        // Shake the letter
        shakingLetterId = letter.id
        
        // Shake the card/page
        shakePage = true
        
        // Turn off shake after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.shakingLetterId = nil
            self.shakePage = false
        }
    }
    
    /// Check if puzzle is completed
    private func checkCompletion() {
        let allPlaced = targetSlots.allSatisfy { $0 != nil }
        
        if allPlaced {
            isCompleted = true
            showSuccessAnimation = true
            
            // Show success view after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showSuccessView = true
            }
        }
    }
    
    /// Reset the current puzzle
    func resetPuzzle() {
        setupPuzzle()
    }
    
    /// Move to next word (same letter)
    func nextWord() {
        loadRandomWord(startingWith: selectedLetter)
    }
    
    /// Move to next letter
    func nextLetter() {
        guard let currentIndex = allLetters.firstIndex(of: selectedLetter) else {
            selectLetter("أ")
            return
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        selectLetter(allLetters[nextIndex])
    }
    
    /// Get current letter index
    func getCurrentLetterIndex() -> Int {
        return allLetters.firstIndex(of: selectedLetter) ?? 0
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
