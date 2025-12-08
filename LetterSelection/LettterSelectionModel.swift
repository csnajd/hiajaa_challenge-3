//
//  LettterSelectionModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import Foundation
import SwiftUI

struct LetterSelectionModel {
    
    // Arabic letters
    var letters: [String] {
        return [
            "أ", "ب", "ت", "ث", "ج", "ح", "خ", "د",
            "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط",
            "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م",
            "ن", "هـ", "و", "ي"
        ]
    }
    
    let pastelColors: [String] = [
        "pink", "purple", "blue", "green",
        "yellow", "orange", "red", "indigo",
        "teal", "mint", "cyan", "brown"
    ]
    
    var swipeInstruction: String {
        return "اسحب لليسار أو اليمين لتغيير الحرف"
    }
    
    var listInstruction: String {
        return "اختر حرفاً من القائمة"
    }
    
    var confirmButtonText: String {
        return "تأكيد"
    }
    
    init() {}
    
    func getColor(for index: Int) -> String {
        return pastelColors[index % pastelColors.count]
    }
}
