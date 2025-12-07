//
//  WordModel.swift
//  hiajaa_challenge 3
//
//  Created by najd aljarba on 16/06/1447 AH.
//
import SwiftUI

// Model used by SpellingView
struct WordModel {
    let word: String
    let imageName: String
    let title: String       // اسم الحيوان أو الكلمة// صورة الحيوان
    let letters: [String]
}

struct LetterItem: Identifiable, Equatable {
    let id = UUID()
    let char: String
    var isPlaced: Bool = false
}

struct DropBox: Identifiable {
    let id = UUID()
    var letter: String? = nil
}



