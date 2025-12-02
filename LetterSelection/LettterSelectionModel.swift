//
//  LettterSelectionModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import Foundation
import SwiftUI
import Foundation

enum AppLanguage: String {
    case english = "en"
    case arabic = "ar"
}

struct LetterSelectionModel {
    let language: AppLanguage
    
    var letters: [String] {
        switch language {
        case .english:
            return [
                "A", "B", "C", "D", "E", "F", "G", "H",
                "I", "J", "K", "L", "M", "N", "O", "P",
                "Q", "R", "S", "T", "U", "V", "W", "X",
                "Y", "Z"
            ]
        case .arabic:
            return [
                "ا", "ب", "ت", "ث", "ج", "ح", "خ", "د",
                "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
                "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
                "ن", "ه", "و", "ي"
            ]
        }
    }
    
    let pastelColors: [String] = [
        "pink", "purple", "blue", "green",
        "yellow", "orange", "red", "indigo",
        "teal", "mint", "cyan", "brown"
    ]
    
    var swipeInstruction: String {
        switch language {
        case .english:
            return "Swipe left or right to change letter"
        case .arabic:
            return "اسحب يميناً أو يساراً لتغيير الحرف"
        }
    }
    
    var listInstruction: String {
        switch language {
        case .english:
            return "Choose a letter from the list"
        case .arabic:
            return "اختر حرفاً من القائمة"
        }
    }
    
    var confirmButtonText: String {
        switch language {
        case .english:
            return "Confirm"
        case .arabic:
            return "تأكيد"
        }
    }
    
    init(language: AppLanguage) {
        self.language = language
    }
    
    func getColor(for index: Int) -> String {
        return pastelColors[index % pastelColors.count]
    }
}
