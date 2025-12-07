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
}

@MainActor
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
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
        path = NavigationPath()
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func goToNextLetter(currentLetter: String, activityType: ActivityType) {
        let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H",
                          "I", "J", "K", "L", "M", "N", "O", "P",
                          "Q", "R", "S", "T", "U", "V", "W", "X",
                          "Y", "Z"]
        
        guard let currentIndex = allLetters.firstIndex(of: currentLetter.uppercased()) else {
            return
        }
        
        let nextIndex = (currentIndex + 1) % allLetters.count
        let nextLetter = allLetters[nextIndex]
        
        // Go back to letter selection level, then push new activity
        path = NavigationPath()
        path.append(AppRoute.letterSelection(activityType))
        
        if activityType == .words {
            path.append(AppRoute.wordView(nextLetter))
        } else {
            path.append(AppRoute.coloringView(nextLetter))
        }
    }
}
