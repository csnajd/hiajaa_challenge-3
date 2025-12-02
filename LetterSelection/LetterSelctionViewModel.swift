//
//  LetterSelctionViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import Foundation
import SwiftUI
internal import Combine




class LetterSelectionViewModel: ObservableObject {
    @Published var currentLetterIndex: Int = 0
    @Published var showListView: Bool = false
    @Published var selectedLetterInList: String? = nil
    @Published var navigateToNextScreen: Bool = false
    @Published var currentLanguage: AppLanguage = .english {
        didSet {
            // Reset state when language changes
            model = LetterSelectionModel(language: currentLanguage)
            currentLetterIndex = 0
            selectedLetterInList = nil
        }
    }
    
    @Published var model: LetterSelectionModel
    
    init(language: AppLanguage = .english) {
        self.currentLanguage = language
        self.model = LetterSelectionModel(language: language)
    }
    
    var currentLetter: String {
        model.letters[currentLetterIndex]
    }
    
    var isConfirmButtonEnabled: Bool {
        if showListView {
            return selectedLetterInList != nil
        }
        return true
    }
    
    var selectedLetter: String {
        showListView ? (selectedLetterInList ?? "") : currentLetter
    }
    
    // MARK: - Actions
    
    func swipeLeft() {
        currentLetterIndex = (currentLetterIndex + 1) % model.letters.count
    }
    
    func swipeRight() {
        currentLetterIndex = (currentLetterIndex - 1 + model.letters.count) % model.letters.count
    }
    
    func toggleListView() {
        showListView.toggle()
        selectedLetterInList = nil
    }
    
    func selectLetter(_ letter: String, at index: Int) {
        selectedLetterInList = letter
        currentLetterIndex = index
    }
    
    func confirmSelection() {
        guard isConfirmButtonEnabled else { return }
        print("Selected letter: \(selectedLetter)")
        navigateToNextScreen = true
    }
    
    func toggleLanguage() {
        currentLanguage = currentLanguage == .english ? .arabic : .english
    }
    
    func getColorName(for index: Int) -> String {
        model.getColor(for: index)
    }
}
