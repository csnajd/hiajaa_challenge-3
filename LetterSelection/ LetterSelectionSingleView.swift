//
//   LetterSelectionSingleView.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import SwiftUI

struct LetterSelectionSingleView: View {
    @ObservedObject var viewModel: LetterSelectionViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Large Letter Card
            RoundedRectangle(cornerRadius: 60)
                .fill(gradientForCurrentLetter())
                .frame(width: 450, height: 500)
                .shadow(color: .black.opacity(0.25), radius: 30, x: 0, y: 15)
                .overlay(
                    Text(viewModel.currentLetter)
                        .font(.system(size: 280, weight: .bold))
                        .foregroundColor(.black.opacity(0.8))
                )
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            if value.translation.width < 0 {
                                viewModel.swipeLeft()
                            } else if value.translation.width > 0 {
                                viewModel.swipeRight()
                            }
                        }
                )
            
            // Navigation Arrows - Outside the card
            HStack(spacing: 100) {
                Button(action: { viewModel.swipeLeft() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                
                Button(action: { viewModel.swipeRight() }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            }
            
            // Progress Indicators
            HStack(spacing: 8) {
                ForEach(0..<min(10, viewModel.model.letters.count), id: \.self) { index in
                    Capsule()
                        .fill(index == viewModel.currentLetterIndex % min(10, viewModel.model.letters.count) ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: index == viewModel.currentLetterIndex % min(10, viewModel.model.letters.count) ? 24 : 8, height: 8)
                        .animation(.spring(), value: viewModel.currentLetterIndex)
                }
            }
        }
        .padding()
    }
    
    private func gradientForCurrentLetter() -> LinearGradient {
        let colorName = viewModel.getColorName(for: viewModel.currentLetterIndex)
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
