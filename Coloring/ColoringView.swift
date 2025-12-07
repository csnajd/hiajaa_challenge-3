//
//  ColoringView.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI

struct ColoringView: View {
    @StateObject private var viewModel: ColoringViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var currentPath = Path()
    
    let selectedLetter: String
    
    init(selectedLetter: String = "A") {
        self.selectedLetter = selectedLetter
        _viewModel = StateObject(wrappedValue: ColoringViewModel(selectedLetter: selectedLetter))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color.pink.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header with back button and done button
                HStack {
                    Button {
                        navigationManager.goBack()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.title3.bold())
                            .foregroundColor(.black)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color(red: 1.0, green: 0.80, blue: 0.70))
                                    .shadow(radius: 4)
                            )
                    }
                    
                    Spacer()
                    
                    // Done button
                    Button {
                        viewModel.markAsComplete()
                    } label: {
                        Text("Done")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.green)
                                    .shadow(radius: 4)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Title
                Text("Color the Letter")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "7B4D2C"))
                
                // Coloring Canvas
                ZStack {
                    // Background card
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 8)
                    
                    // Letter outline
                    Text(viewModel.selectedLetter)
                        .font(.system(size: 350, weight: .bold))
                        .foregroundColor(Color.gray.opacity(0.2))
                    
                    // Colored paths
                    ForEach(viewModel.coloredPaths) { coloredPath in
                        coloredPath.path
                            .stroke(coloredPath.color, style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                    }
                    
                    // Current drawing path
                    currentPath
                        .stroke(viewModel.selectedColor, style: StrokeStyle(lineWidth: 25, lineCap: .round, lineJoin: .round))
                }
                .frame(width: 450, height: 450)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            if currentPath.isEmpty {
                                currentPath.move(to: point)
                            } else {
                                currentPath.addLine(to: point)
                            }
                        }
                        .onEnded { _ in
                            viewModel.addPath(currentPath)
                            currentPath = Path()
                        }
                )
                
                // Color palette
                VStack(spacing: 15) {
                    Text("Choose a Color")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 20) {
                        ForEach(viewModel.availableColors, id: \.self) { color in
                            ColorButton(
                                color: color,
                                isSelected: viewModel.selectedColor == color,
                                action: {
                                    viewModel.selectColor(color)
                                }
                            )
                        }
                    }
                }
                .padding(.vertical, 20)
                
                // Clear button
                Button {
                    viewModel.clearColoring()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.8))
                            .shadow(radius: 4)
                    )
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.showSuccessView) { _, newValue in
            if newValue {
                let data = SuccessData(
                    selectedAvatar: "avatar1",
                    correctWord: viewModel.selectedLetter,
                    imageName: "letter_\(viewModel.selectedLetter.lowercased())",
                    activityType: .coloring,
                    currentLetter: selectedLetter
                )
                navigationManager.navigateToSuccess(data: data)
                viewModel.showSuccessView = false
            }
        }
    }
}

// MARK: - Color Button

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: isSelected ? 55 : 45, height: isSelected ? 55 : 45)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                )
                .shadow(color: isSelected ? color.opacity(0.5) : .black.opacity(0.2),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2)
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Preview

struct ColoringView_Previews: PreviewProvider {
    static var previews: some View {
        ColoringView(selectedLetter: "A")
            .previewDevice("iPad (10th generation)")
    }
}
