//
//  ColoringView.swift
//  hiajaa_challenge 3
//
//  Created by Latifa Farhan Al-Mawash on 16/06/1447 AH.
//

import SwiftUI
import AVFoundation
internal import Combine



struct ColoringView: View {
    // MARK: - Properties
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: ColoringViewModel
    @StateObject private var audioManager = DrawingAudioManager()
    
    let selectedLetter: String
    
    // Zoom state
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    // For capturing the drawing
    @State private var capturedDrawingData: Data?
    
    init(selectedLetter: String = "أ") {
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
                    selectedAvatar: navigationManager.selectedAvatar,
                    correctWord: viewModel.selectedLetter,
                    imageName: "letter_\(viewModel.selectedLetter.lowercased())",
                    activityType: .coloring,
                    currentLetter: selectedLetter,
                    drawingImageData: capturedDrawingData
                )
                navigationManager.navigateToSuccess(data: data)
                viewModel.showSuccessView = false
            }
        }
        .onDisappear {
            audioManager.stopDrawingSound()
        }
    }
    
    // MARK: - Capture Drawing as Image
    @MainActor
    private func captureDrawing() {
        // Get the actual canvas size - use a reasonable capture size
        let canvasSize = CGSize(width: 400, height: 500)
        
        // Calculate scale factor to map drawing coordinates to capture size
        // The drawing happens in the full screen canvas, so we need to scale appropriately
        let screenBounds = UIScreen.main.bounds
        let scaleX = canvasSize.width / screenBounds.width
        let scaleY = canvasSize.height / screenBounds.height
        let scale = min(scaleX, scaleY)
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize)
        let image = renderer.image { context in
            let cgContext = context.cgContext
            
            // White background
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: canvasSize))
            
            // Draw the letter outline in center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let letterFontSize: CGFloat = 180
            let attributes: [NSAttributedString.Key: Any] = [
                .strokeColor: UIColor.black.withAlphaComponent(0.6),
                .strokeWidth: 3.0,
                .font: UIFont.systemFont(ofSize: letterFontSize, weight: .regular),
                .foregroundColor: UIColor.clear,
                .paragraphStyle: paragraphStyle
            ]
            
            let textSize = viewModel.selectedLetter.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (canvasSize.width - textSize.width) / 2,
                y: (canvasSize.height - textSize.height) / 2 - 20,
                width: textSize.width,
                height: textSize.height
            )
            viewModel.selectedLetter.draw(in: textRect, withAttributes: attributes)
            
            // Draw all the user's paths - scale them to fit the capture size
            // The paths were drawn on the full screen, so we need to transform them
            cgContext.saveGState()
            
            // Translate to center and scale
            let offsetX = canvasSize.width / 2 - (screenBounds.width * scale) / 2
            let offsetY = canvasSize.height / 2 - (screenBounds.height * scale) / 2
            cgContext.translateBy(x: offsetX, y: offsetY)
            cgContext.scaleBy(x: scale, y: scale)
            
            for drawingPath in viewModel.drawingPaths {
                guard drawingPath.points.count > 1 else { continue }
                
                let bezierPath = UIBezierPath()
                bezierPath.move(to: drawingPath.points[0])
                
                for point in drawingPath.points.dropFirst() {
                    bezierPath.addLine(to: point)
                }
                
                let lineWidth = drawingPath.isEraser ? DrawingConstants.eraserLineWidth : DrawingConstants.normalLineWidth
                bezierPath.lineWidth = lineWidth / scale  // Adjust line width for scale
                bezierPath.lineCapStyle = .round
                bezierPath.lineJoinStyle = .round
                
                UIColor(drawingPath.color).setStroke()
                bezierPath.stroke()
            }
            
            cgContext.restoreGState()
        }
        
        capturedDrawingData = image.pngData()
    }
    
    // MARK: - View Components
    
    private var headerButtons: some View {
        HStack {
            // Done button on the left
            Button(action: {
                // Capture the drawing first, then mark complete
                captureDrawing()
                viewModel.markAsComplete()
            }) {
                Text("تم")
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
            
            Spacer()
            
            // Reset zoom button
            Button(action: {
                withAnimation(.spring()) {
                    currentScale = 1.0
                    lastScale = 1.0
                    offset = .zero
                    lastOffset = .zero
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: DrawingConstants.buttonSize, height: DrawingConstants.buttonSize)
                    
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            Spacer().frame(width: 16)
            
            // Back button on the right
            Button(action: {
                navigationManager.goBack()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: DrawingConstants.buttonSize, height: DrawingConstants.buttonSize)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
    
    private var drawingCanvas: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                
                // Letter with only black stroke outline (no fill) - using UIKit approach
                StrokedText(text: viewModel.selectedLetter, fontSize: 350, strokeWidth: 2, strokeColor: .black.opacity(0.6))
                
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
            .scaleEffect(currentScale)
            .offset(offset)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = lastScale * value
                        currentScale = min(max(newScale, 0.5), 4.0)
                    }
                    .onEnded { _ in
                        lastScale = currentScale
                    }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        viewModel.addPoint(value.location)
                        audioManager.startDrawingSound()
                    }
                    .onEnded { _ in
                        viewModel.finishDrawing()
                        audioManager.stopDrawingSound()
                    }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
    
    private var colorPaletteSection: some View {
        HStack(spacing: 30) {
            eraserButton
            colorPalette
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

// MARK: - Drawing Audio Manager

class DrawingAudioManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published private var isCurrentlyPlaying = false
    
    func startDrawingSound() {
        // Only start if not already playing
        guard !isCurrentlyPlaying else { return }
        
        // Setup audio player if needed
        if audioPlayer == nil {
            setupAudioPlayer()
        }
        
        audioPlayer?.play()
        isCurrentlyPlaying = true
    }
    
    func stopDrawingSound() {
        audioPlayer?.pause()
        audioPlayer?.currentTime = 0
        isCurrentlyPlaying = false
    }
    
    private func setupAudioPlayer() {
        // Try different extensions
        let extensions = ["mp3", "wav", "m4a", "aac", "caf", "aiff", "mp4", ""]
        var soundURL: URL?
        
        // Debug: Print all audio files in bundle
        if let resourcePath = Bundle.main.resourcePath {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                let audioFiles = files.filter { $0.lowercased().contains("drawing") }
                print("🔍 Files containing 'drawing': \(audioFiles)")
            } catch {
                print("❌ Could not list bundle files")
            }
        }
        
        for ext in extensions {
            if let url = Bundle.main.url(forResource: "drawing", withExtension: ext.isEmpty ? nil : ext) {
                soundURL = url
                print("✅ Found audio file with extension: \(ext.isEmpty ? "none" : ext)")
                break
            }
        }
        
        guard let url = soundURL else {
            print("⚠️ Drawing sound file not found. Make sure 'drawing' audio file is added to the project.")
            return
        }
        
        do {
            // Configure audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Create player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Loop forever while drawing
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            
            print("✅ Drawing sound loaded successfully from: \(url.lastPathComponent)")
        } catch {
            print("❌ Failed to setup audio: \(error.localizedDescription)")
        }
    }
}

// MARK: - Stroked Text View (UIKit-based for proper outline)

struct StrokedText: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let strokeWidth: CGFloat
    let strokeColor: Color
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor(strokeColor),
            .strokeWidth: strokeWidth,  // Positive value = stroke only, no fill
            .font: UIFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: UIColor.clear
        ]
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
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
