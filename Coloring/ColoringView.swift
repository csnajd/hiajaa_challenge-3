//
//  ColoringView.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI

struct ColoringView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ColoringViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                backButton
                
                Spacer()
                
                drawingCanvas
                
                colorPaletteSection
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - View Components
    
    private var backButton: some View {
        HStack {
            Button(action: {
                dismiss()
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
            .padding(.leading, 30)
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    private var drawingCanvas: some View {
        ZStack {
            Color.white
            
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
                    ColorButton(
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

// MARK: - Color Button Component
struct ColorButton: View {
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

// MARK: - Preview
#Preview {
    ColoringView()
}
