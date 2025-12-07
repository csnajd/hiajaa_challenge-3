//
//  WordpuzzleModel.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 04/12/2025.
//
//
//  WordpuzzleModel.swift
//  hiajaa_challenge_3
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
let allWords: [WordModel ] = [
    // First group
    WordModel (imageName: "books", word: "books"),
    WordModel (imageName: "cloud", word: "cloud"),
    WordModel (imageName: "elphant", word: "elephant"),
    WordModel (imageName: "envlope", word: "envelope"),
    WordModel (imageName: "fish", word: "fish"),
    WordModel (imageName: "flower", word: "flower"),
    WordModel (imageName: "frog", word: "frog"),
    WordModel (imageName: "gift", word: "gift"),
    WordModel (imageName: "honey", word: "honey"),
    WordModel (imageName: "key", word: "key"),
    WordModel (imageName: "lemon", word: "lemon"),
    WordModel (imageName: "moon", word: "moon"),
    WordModel (imageName: "plane", word: "plane"),
    WordModel (imageName: "Rocket", word: "rocket"),
    WordModel (imageName: "Sun", word: "sun"),
    
    // Second group
    WordModel (imageName: "Apple", word: "apple"),
    WordModel (imageName: "Bear", word: "bear"),
    WordModel (imageName: "Camel", word: "camel"),
    WordModel (imageName: "Corn", word: "corn"),
    WordModel (imageName: "Cucumber", word: "cucumber"),
    WordModel (imageName: "Door", word: "door"),
    WordModel (imageName: "Giraffe", word: "giraffe"),
    WordModel (imageName: "Horse", word: "horse"),
    WordModel (imageName: "Lion", word: "lion"),
    WordModel (imageName: "Pomegranate", word: "pomegranate"),
    WordModel (imageName: "Thobe", word: "thobe")
]
