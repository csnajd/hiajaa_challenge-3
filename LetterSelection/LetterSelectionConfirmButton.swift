//
//  LetterSelectionConfirmButton.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import SwiftUI
struct LetterSelectionConfirmButton: View {
    let isEnabled: Bool
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(isEnabled ? .black.opacity(0.8) : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    Capsule()
                        .fill(isEnabled ? Color(red: 0.8, green: 0.95, blue: 0.5) : Color.gray.opacity(0.3))
                )
                .shadow(color: isEnabled ? .black.opacity(0.1) : .clear, radius: 10, x: 0, y: 4)
                .scaleEffect(isEnabled ? 1.0 : 0.98)
        }
        .disabled(!isEnabled)
        .animation(.spring(response: 0.3), value: isEnabled)
    }
}
