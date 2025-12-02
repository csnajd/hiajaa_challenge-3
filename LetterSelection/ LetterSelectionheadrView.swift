//
//   LetterSelectionheadrView.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import SwiftUI

struct LetterSelectionHeaderView: View {
    var onClose: () -> Void
    var onToggleList: () -> Void
    var onToggleLanguage: () -> Void
    var currentLanguage: AppLanguage
    
    var body: some View {
        HStack {
            Button(action: onClose) {
                Circle()
                    .fill(Color.red.opacity(0.3))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            
            Spacer()
            
            // Language Toggle Button
            Button(action: onToggleLanguage) {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(currentLanguage == .english ? "ع" : "A")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            
            Button(action: onToggleList) {
                Circle()
                    .fill(Color.yellow.opacity(0.4))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "list.bullet")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
        }
    }
}
