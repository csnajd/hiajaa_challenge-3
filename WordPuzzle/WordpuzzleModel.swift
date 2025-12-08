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
    let startLetter: String  // The Arabic letter this word starts with
    let soundName: String    // Name of the audio file for this word
    
    var letters: [String] {
        word.map { String($0) }
    }
}

// MARK: - Arabic Words Data
// Sound files should be named: apple.mp3, lion.mp3, door.mp3, etc.
let allWords: [WordModel] = [
    // أ - Alef
    
    WordModel(imageName: "Lion", word: "أسد", startLetter: "أ", soundName: "Lion"),
    
    // ب - Ba
    WordModel(imageName: "Door", word: "باب", startLetter: "ب", soundName: "door"),
  
    
    // ت - Ta
    WordModel(imageName: "Apple", word: "تفاحة", startLetter: "ت", soundName: "apple"),
    
    // ث - Tha
    WordModel(imageName: "Thobe", word: "ثوب", startLetter: "ث", soundName: "thobe"),
    
    // ج - Jeem
    WordModel(imageName: "Camel", word: "جمل", startLetter: "ج", soundName: "camel"),
    
    // ح - Ha
    WordModel(imageName: "Horse", word: "حصان", startLetter: "ح", soundName: "horse"),
    
    // خ - Kha
    WordModel(imageName: "Cucumber", word: "خيار", startLetter: "خ", soundName: "cucumber"),
    
    // د - Dal
    WordModel(imageName: "Bear", word: "دب", startLetter: "د", soundName: "bear"),
    
    // ذ - Thal
    WordModel(imageName: "Corn", word: "ذرة", startLetter: "ذ", soundName: "corn"),
    
    // ر - Ra
    WordModel(imageName: "Rocket", word: "صاروخ", startLetter: "ر", soundName: "rocket"),
    
    // ز - Zay
   
    WordModel(imageName: "Giraffe", word: "زرافة", startLetter: "ز", soundName: "giraffe"),
    
    // س - Seen
    WordModel(imageName: "fish", word: "سمكة", startLetter: "س", soundName: "fish"),
   
    
    // ش - Sheen
    WordModel(imageName: "Sun", word: "شمس", startLetter: "ش", soundName: "sun"),
    
    // ص - Sad
    WordModel(imageName: "Rocket", word: "صاروخ", startLetter: "ص", soundName: "rocket"),
    
    // ض - Dad
    WordModel(imageName: "frog", word: "ضفدع", startLetter: "ض", soundName: "frog"),
    
    // ط - Ta
    WordModel(imageName: "plane", word: "طائرة", startLetter: "ط", soundName: "plane"),
    
    // ظ - Za
    WordModel(imageName: "envlope", word: "ظرف", startLetter: "ظ", soundName: "envelope"),
    
    // ع - Ain
    WordModel(imageName: "honey", word: "عسل", startLetter: "ع", soundName: "honey"),
    
    // غ - Ghain
    WordModel(imageName: "cloud", word: "غيمة", startLetter: "غ", soundName: "cloud"),
    
    // ف - Fa
    WordModel(imageName: "elphant", word: "فيل", startLetter: "ف", soundName: "elephant"),
    
    // ق - Qaf
    WordModel(imageName: "moon", word: "قمر", startLetter: "ق", soundName: "moon"),
    
    // ك - Kaf
    WordModel(imageName: "books", word: "كتاب", startLetter: "ك", soundName: "book"),
    
    // ل - Lam
    WordModel(imageName: "lemon", word: "ليمون", startLetter: "ل", soundName: "lemon"),
    
    // م - Meem
    WordModel(imageName: "key", word: "مفتاح", startLetter: "م", soundName: "key"),
    
    // ن - Noon
    WordModel(imageName: "gift", word: "نجمة", startLetter: "ن", soundName: "star"),
    
    // هـ - Ha
    WordModel(imageName: "gift", word: "هدية", startLetter: "هـ", soundName: "gift"),
    
    // و - Waw
    WordModel(imageName: "flower", word: "وردة", startLetter: "و", soundName: "rose"),
    
    // ي - Ya
    WordModel(imageName: "Pomegranate", word: "يد", startLetter: "ي", soundName: "hand")
]
