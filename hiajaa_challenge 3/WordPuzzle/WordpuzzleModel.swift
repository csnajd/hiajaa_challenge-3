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

struct WordPuzzleModel: Identifiable {
    let id = UUID()
    let imageName: String      // asset name
    let word: String           // correct word

    var letters: [String] {
        word.map { String($0) }
    }
}

// MARK: - Words Data

let allWords: [WordPuzzleModel] = [

    // First group
    WordPuzzleModel(imageName: "books", word: "books"),
    WordPuzzleModel(imageName: "cloud", word: "cloud"),
    WordPuzzleModel(imageName: "elphant", word: "elephant"),
    WordPuzzleModel(imageName: "envlope", word: "envelope"),
    WordPuzzleModel(imageName: "fish", word: "fish"),
    WordPuzzleModel(imageName: "flower", word: "flower"),
    WordPuzzleModel(imageName: "frog", word: "frog"),
    WordPuzzleModel(imageName: "gift", word: "gift"),
    WordPuzzleModel(imageName: "honey", word: "honey"),
    WordPuzzleModel(imageName: "key", word: "key"),
    WordPuzzleModel(imageName: "lemon", word: "lemon"),
    WordPuzzleModel(imageName: "moon", word: "moon"),
    WordPuzzleModel(imageName: "plane", word: "plane"),
    WordPuzzleModel(imageName: "Rocket", word: "rocket"),
    WordPuzzleModel(imageName: "Sun", word: "sun"),

    // Second group
    WordPuzzleModel(imageName: "Apple", word: "apple"),
    WordPuzzleModel(imageName: "Bear", word: "bear"),
    WordPuzzleModel(imageName: "Camel", word: "camel"),
    WordPuzzleModel(imageName: "Corn", word: "corn"),
    WordPuzzleModel(imageName: "Cucumber", word: "cucumber"),
    WordPuzzleModel(imageName: "Door", word: "door"),
    WordPuzzleModel(imageName: "Giraffe", word: "giraffe"),
    WordPuzzleModel(imageName: "Horse", word: "horse"),
    WordPuzzleModel(imageName: "Lion", word: "lion"),
    WordPuzzleModel(imageName: "Pomegranate", word: "pomegranate"),
    WordPuzzleModel(imageName: "Thobe", word: "thobe")
]
