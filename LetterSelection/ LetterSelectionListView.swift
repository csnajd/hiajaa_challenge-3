//
//   LetterSelectionListView.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import SwiftUI

struct LetterSelectionListView: View {
    @ObservedObject var viewModel: LetterSelectionViewModel
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(viewModel.model.letters.enumerated()), id: \.offset) { index, letter in
                    Button(action: {
                        viewModel.selectLetter(letter, at: index)
                    }) {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(gradientForLetter(at: index))
                            .frame(height: 100)
                            .overlay(
                                Text(letter)
                                    .font(.system(size: 52, weight: .bold))
                                    .foregroundColor(.black.opacity(0.8))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(
                                        viewModel.selectedLetterInList == letter ? Color.white : Color.clear,
                                        lineWidth: 5
                                    )
                            )
                            .scaleEffect(viewModel.selectedLetterInList == letter ? 1.08 : 1.0)
                            .shadow(
                                color: viewModel.selectedLetterInList == letter ? .white.opacity(0.5) : .black.opacity(0.15),
                                radius: viewModel.selectedLetterInList == letter ? 15 : 8,
                                x: 0,
                                y: viewModel.selectedLetterInList == letter ? 8 : 4
                            )
                            .animation(.spring(response: 0.3), value: viewModel.selectedLetterInList)
                    }
                }
            }
            .padding(24)
        }
        .padding(.horizontal, 16)
    }
    
    private func gradientForLetter(at index: Int) -> LinearGradient {
        let colorName = viewModel.getColorName(for: index)
        let colors = getGradientColors(for: colorName)
        
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func getGradientColors(for colorName: String) -> [Color] {
        switch colorName {
        case "pink": return [Color.pink.opacity(0.25), Color.pink.opacity(0.35)]
        case "purple": return [Color.purple.opacity(0.25), Color.purple.opacity(0.35)]
        case "blue": return [Color.blue.opacity(0.25), Color.blue.opacity(0.35)]
        case "green": return [Color.green.opacity(0.25), Color.green.opacity(0.35)]
        case "yellow": return [Color.yellow.opacity(0.25), Color.yellow.opacity(0.35)]
        case "orange": return [Color.orange.opacity(0.25), Color.orange.opacity(0.35)]
        case "red": return [Color.red.opacity(0.25), Color.red.opacity(0.35)]
        case "indigo": return [Color.indigo.opacity(0.25), Color.indigo.opacity(0.35)]
        case "teal": return [Color.teal.opacity(0.25), Color.teal.opacity(0.35)]
        case "mint": return [Color.mint.opacity(0.25), Color.mint.opacity(0.35)]
        case "cyan": return [Color.cyan.opacity(0.25), Color.cyan.opacity(0.35)]
        case "brown": return [Color.brown.opacity(0.25), Color.brown.opacity(0.35)]
        default: return [Color.gray.opacity(0.25), Color.gray.opacity(0.35)]
        }
    }
}
