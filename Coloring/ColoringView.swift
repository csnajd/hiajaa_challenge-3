//
//  ColoringView.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI

struct ColoringView: View {
    // MARK: - Properties
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: ColoringViewModel
    
    let selectedLetter: String
    
    init(selectedLetter: String = "A") {
        self.selectedLetter = selectedLetter
        _viewModel = StateObject(wrappedValue: ColoringViewModel(selectedLetter: selectedLetter))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                headerButtons
                
                Spacer()
                
                drawingCanvas
                
                colorPaletteSection
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
    
    // MARK: - View Components
    
    private var headerButtons: some View {
        HStack {
            // Back button
            Button(action: {
                navigationManager.goBack()
            }) {
                ZStack {
                    Circle()
                        .fill(Color("BackButtonColor"))
                        .frame(width: DrawingConstants.buttonSize, height: DrawingConstants.buttonSize)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
            
            // Done button
            Button(action: {
                viewModel.markAsComplete()
            }) {
                Text("Done")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.green)
                            .shadow(radius: 4)
                    )
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
    
    private var drawingCanvas: some View {
        ZStack {
            Color.white
            
            // Letter outline
            Text(viewModel.selectedLetter)
                .font(.system(size: 350, weight: .bold))
                .foregroundColor(Color.gray.opacity(0.2))
            
            Canvas { context, size in
                // Draw all paths
                for drawingPath in viewModel.drawingPaths {
                    var path = Path()
                    if let firstPoint = drawingPath.points.first {
                        path.move(to: firstPoint)
                        for point in drawingPath.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(
                        path,
                        with: .color(drawingPath.color),
                        style: StrokeStyle(
                            lineWidth: viewModel.getLineWidth(for: drawingPath),
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                }
                
                // Draw current path
                if !viewModel.currentPath.isEmpty {
                    var path = Path()
                    path.move(to: viewModel.currentPath[0])
                    for point in viewModel.currentPath.dropFirst() {
                        path.addLine(to: point)
                    }
                    context.stroke(
                        path,
                        with: .color(viewModel.getCurrentColor()),
                        style: StrokeStyle(
                            lineWidth: viewModel.getCurrentLineWidth(),
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    viewModel.addPoint(value.location)
                }
                .onEnded { _ in
                    viewModel.finishDrawing()
                }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var colorPaletteSection: some View {
        HStack(spacing: 30) {
            colorPalette
            eraserButton
        }
        .padding(.bottom, 50)
    }
    
    private var colorPalette: some View {
        ZStack {
            Capsule()
                .fill(Color("PaletteColor"))
                .frame(width: DrawingConstants.paletteWidth, height: DrawingConstants.paletteHeight)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            HStack(spacing: 35) {
                ForEach(viewModel.availableColors, id: \.assetName) { colorPalette in
                    ColoringColorButton(
                        color: Color(colorPalette.assetName),
                        isSelected: viewModel.isColorSelected(Color(colorPalette.assetName))
                    ) {
                        viewModel.selectColor(Color(colorPalette.assetName))
                    }
                }
            }
        }
    }
    
    private var eraserButton: some View {
        Button(action: {
            viewModel.selectEraser()
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: DrawingConstants.eraserCircleSize, height: DrawingConstants.eraserCircleSize)
                    .overlay(
                        Circle()
                            .stroke(
                                viewModel.isErasing ? Color.blue : Color.gray.opacity(0.3),
                                lineWidth: viewModel.isErasing ? 4 : 2
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Image(systemName: "eraser.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Coloring Color Button

struct ColoringColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: DrawingConstants.colorCircleSize, height: DrawingConstants.colorCircleSize)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                )
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
}
