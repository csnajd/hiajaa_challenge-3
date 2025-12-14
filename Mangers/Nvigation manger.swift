//
//  Nvigation manger.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 07/12/2025.
//
import SwiftUI
internal import Combine

// MARK: - Routes
enum AppRoute: Hashable {
    case avatarSelection            // ← أضفناه هنا
    case letterSelection(ActivityType)
    case wordView(String)
    case coloringView(String)
    case successView(SuccessData)
}


// MARK: - Success Data
struct SuccessData: Hashable {
    let selectedAvatar: String
    let correctWord: String
    let imageName: String
    let activityType: ActivityType
    let currentLetter: String
    let drawingImageData: Data?
    
    init(selectedAvatar: String, correctWord: String, imageName: String, activityType: ActivityType, currentLetter: String, drawingImageData: Data? = nil) {
        self.selectedAvatar = selectedAvatar
        self.correctWord = correctWord
        self.imageName = imageName
        self.activityType = activityType
        self.currentLetter = currentLetter
        self.drawingImageData = drawingImageData
    }
    
    var drawingImage: UIImage? {
        guard let data = drawingImageData else { return nil }
        return UIImage(data: data)
    }
}


// MARK: - Navigation Manager
@MainActor
class NavigationManager: ObservableObject {

    @Published var path = NavigationPath()
    @Published var selectedAvatar: String = "avatar1"

    
    // --------- Avatar ---------
    func setAvatar(_ avatar: String) {
        selectedAvatar = avatar
    }
    
    func goToAvatarSelection() {
        path.append(AppRoute.avatarSelection)
    }
    
    
    // --------- Navigation Routes ---------
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
    
    
    // --------- Go Home ---------
    func goToHome() {
        /// يرجع لأول صفحة (HomeView)
        path = NavigationPath()
    }
    
    
    // --------- Back ---------
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    
    // --------- Next Letter ---------
    func goToNextLetter(currentLetter: String, activityType: ActivityType) {
        
        let allLetters = [
            "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
            "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
            "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
            "ن", "هـ", "و", "ي"
        ]
        
        var currentIndex = allLetters.firstIndex(of: currentLetter) ?? -1
        
        if currentIndex == -1 {
            for (index, letter) in allLetters.enumerated() {
                if letter.contains(currentLetter) || currentLetter.contains(letter) {
                    currentIndex = index
                    break
                }
            }
        }
        
        if currentIndex == -1 {
            currentIndex = 0
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        let nextLetter = allLetters[nextIndex]
        
        // Reset + Home
        path = NavigationPath()
        
        if activityType == .words {
            path.append(AppRoute.wordView(nextLetter))
        } else {
            path.append(AppRoute.coloringView(nextLetter))
        }
    }
}
