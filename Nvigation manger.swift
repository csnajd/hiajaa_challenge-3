//
//  Nvigation manger.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 07/12/2025.
//

import SwiftUI
internal import Combine


enum AppRoute: Hashable {
    case letterSelection(ActivityType)
    case wordView(String)
    case coloringView(String)
    case successView(SuccessData)
}

struct SuccessData: Hashable {
    let selectedAvatar: String
    let correctWord: String
    let imageName: String
    let activityType: ActivityType
    let currentLetter: String
    let drawingImageData: Data?  // For coloring activity - stores the drawing as PNG data
    
    init(selectedAvatar: String, correctWord: String, imageName: String, activityType: ActivityType, currentLetter: String, drawingImageData: Data? = nil) {
        self.selectedAvatar = selectedAvatar
        self.correctWord = correctWord
        self.imageName = imageName
        self.activityType = activityType
        self.currentLetter = currentLetter
        self.drawingImageData = drawingImageData
    }
    
    // Convert Data to UIImage for display
    var drawingImage: UIImage? {
        guard let data = drawingImageData else { return nil }
        return UIImage(data: data)
    }
}

@MainActor
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedAvatar: String = "avatar1"  // Store the selected avatar
    
    func setAvatar(_ avatar: String) {
        selectedAvatar = avatar
    }
    
    func navigateToLetterSelection(activityType: ActivityType) {
        path.append(AppRoute.letterSelection(activityType))
    }
    
    func navigateToWordView(letter: String) {
        path.append(AppRoute.wordView(letter))
    }
    
    func navigateToColoringView(letter: String) {
        path.append(AppRoute.coloringView(letter))
    }
    
    func navigateToSuccess(data: SuccessData) {
        path.append(AppRoute.successView(data))
    }
    
    func goToHome() {
        // Remove all routes except "home"
        path = NavigationPath()
        path.append("home")
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func goToNextLetter(currentLetter: String, activityType: ActivityType) {
        let allLetters = [
            "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
            "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
            "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
            "ن", "هـ", "و", "ي"
        ]
        
        guard let currentIndex = allLetters.firstIndex(of: currentLetter) else {
            return
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        let nextLetter = allLetters[nextIndex]
        
        // Go back to home, then push letter selection and activity
        path = NavigationPath()
        path.append("home")
        path.append(AppRoute.letterSelection(activityType))
        
        if activityType == .words {
            path.append(AppRoute.wordView(nextLetter))
        } else {
            path.append(AppRoute.coloringView(nextLetter))
        }
    }
}
