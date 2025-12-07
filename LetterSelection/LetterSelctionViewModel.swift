//
//  LetterSelctionViewModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import Foundation
import SwiftUI
internal import Combine

@MainActor
class LetterSelectionViewModel: ObservableObject {
    @Published var currentLetterIndex: Int = 0
    @Published var showListView: Bool = false
    @Published var selectedLetterInList: String? = nil
    @Published var navigateToNextScreen: Bool = false
    
    @Published var model: LetterSelectionModel
    
    // Track which activity was selected (coloring or words)
    var activityType: ActivityType
    
    init(activityType: ActivityType = .words) {
        self.activityType = activityType
        self.model = LetterSelectionModel()
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
        print("Selected letter: \(selectedLetter) for activity: \(activityType.rawValue)")
        navigateToNextScreen = true
    }
    
    func getColorName(for index: Int) -> String {
        model.getColor(for: index)
    }
}
