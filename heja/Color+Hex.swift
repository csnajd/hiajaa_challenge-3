//
//  Color+Hex.swift
//  hiajaa_challenge 3
//
//  Created by najd aljarba on 16/06/1447 AH.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)
        
        self.init(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: 1
        )
    }
}
