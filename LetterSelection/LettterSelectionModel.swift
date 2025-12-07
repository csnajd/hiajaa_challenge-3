//
//  LettterSelectionModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import Foundation
import SwiftUI

struct LetterSelectionModel {
    
    var letters: [String] {
        return [
            "A", "B", "C", "D", "E", "F", "G", "H",
            "I", "J", "K", "L", "M", "N", "O", "P",
            "Q", "R", "S", "T", "U", "V", "W", "X",
            "Y", "Z"
        ]
    }
    
    let pastelColors: [String] = [
        "pink", "purple", "blue", "green",
        "yellow", "orange", "red", "indigo",
        "teal", "mint", "cyan", "brown"
    ]
    
    var swipeInstruction: String {
        return "Swipe left or right to change letter"
    }
    
    var listInstruction: String {
        return "Choose a letter from the list"
    }
    
    var confirmButtonText: String {
        return "Confirm"
    }
    
    init() {}
    
    func getColor(for index: Int) -> String {
        return pastelColors[index % pastelColors.count]
    }
}
