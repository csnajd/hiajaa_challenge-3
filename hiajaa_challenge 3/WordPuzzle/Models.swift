//
//  Models.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 07/12/2025.
//

import Foundation
import SwiftUI

struct Letter: Identifiable, Equatable {
    let id = UUID()
    let character: String
    let correctPosition: Int
    var currentPosition: Int?
    var isPlaced: Bool = false
    var color: Color
    
    static func == (lhs: Letter, rhs: Letter) -> Bool {
        lhs.id == rhs.id
    }
}

struct WordModel: Identifiable {
    let id = UUID()
    let imageName: String
    let word: String
    
    var letters: [String] {
        word.map { String($0) }
    }
}

// MARK: - Words Data
let allWords: [WordModel] = [
    // A
    WordModel(imageName: "Apple", word: "apple"),
    
    // B
    WordModel(imageName: "books", word: "books"),
    WordModel(imageName: "Bear", word: "bear"),
    
    // C
    WordModel(imageName: "cloud", word: "cloud"),
    WordModel(imageName: "Camel", word: "camel"),
    WordModel(imageName: "Corn", word: "corn"),
    WordModel(imageName: "Cucumber", word: "cucumber"),
    
    // D
    WordModel(imageName: "Door", word: "door"),
    
    // E
    WordModel(imageName: "elphant", word: "elephant"),
    WordModel(imageName: "envlope", word: "envelope"),
    
    // F
    WordModel(imageName: "fish", word: "fish"),
    WordModel(imageName: "flower", word: "flower"),
    WordModel(imageName: "frog", word: "frog"),
    
    // G
    WordModel(imageName: "gift", word: "gift"),
    WordModel(imageName: "Giraffe", word: "giraffe"),
    
    // H
    WordModel(imageName: "honey", word: "honey"),
    WordModel(imageName: "Horse", word: "horse"),
    
    // K
    WordModel(imageName: "key", word: "key"),
    
    // L
    WordModel(imageName: "lemon", word: "lemon"),
    WordModel(imageName: "Lion", word: "lion"),
    
    // M
    WordModel(imageName: "moon", word: "moon"),
    
    // P
    WordModel(imageName: "plane", word: "plane"),
    WordModel(imageName: "Pomegranate", word: "pomegranate"),
    
    // R
    WordModel(imageName: "Rocket", word: "rocket"),
    
    // S
    WordModel(imageName: "Sun", word: "sun"),
    
    // T
    WordModel(imageName: "Thobe", word: "thobe")
]
