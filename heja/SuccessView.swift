import SwiftUI

// MARK: - Confetti Piece
struct ConfettiPiece: View {
    let color: Color
    @State private var position: CGPoint
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    init(color: Color, screenWidth: CGFloat, screenHeight: CGFloat) {
        self.color = color
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self._position = State(initialValue: CGPoint(
            x: CGFloat.random(in: 0...screenWidth),
            y: -20
        ))
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: CGFloat.random(in: 8...15), height: CGFloat.random(in: 15...25))
            .position(position)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.linear(duration: Double.random(in: 2.5...4.0))) {
                    position = CGPoint(
                        x: position.x + CGFloat.random(in: -100...100),
                        y: screenHeight + 50
                    )
                    rotation = Double.random(in: 360...720)
                }
                withAnimation(Animation.linear(duration: 3.5).delay(1.5)) {
                    opacity = 0
                }
            }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    @State private var confettiPieces: [Int] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces, id: \.self) { _ in
                    ConfettiPiece(
                        color: colors.randomElement()!,
                        screenWidth: geometry.size.width,
                        screenHeight: geometry.size.height
                    )
                }
            }
            .onAppear {
                // Create 50 confetti pieces
                confettiPieces = Array(0..<50)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Success View
struct SuccessView: View {

    let selectedAvatar: String
    let correctWord: String
    let imageName: String
    let activityType: ActivityType
    let currentLetter: String
    let drawingImageData: Data?
    
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var showAlert = false
    @State private var showConfetti = true
    
    // Convert Data to UIImage
    var drawingImage: UIImage? {
        guard let data = drawingImageData else { return nil }
        return UIImage(data: data)
    }
    
    // Custom initializer to work with SuccessData
    init(data: SuccessData) {
        self.selectedAvatar = data.selectedAvatar
        self.correctWord = data.correctWord
        self.imageName = data.imageName
        self.activityType = data.activityType
        self.currentLetter = data.currentLetter
        self.drawingImageData = data.drawingImageData
    }

    var body: some View {
        ZStack {
            VStack(spacing: 32) {

                // Title
                Text("ممتاز!")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(Color(hex: "CE845A"))

                Text("أحسنت ⭐️")
                    .font(.system(size: 26))
                    .foregroundColor(.black.opacity(0.75))


                // Background with avatar
                ZStack {

                    // Background image
                    Image("success_bg")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 750)
                        .offset(y: -20)

                    // Avatar inside circle
                    Image(selectedAvatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .offset(y: -90)
                }
                .padding(.top, 10)


                // Result card
                if activityType == .words {
                    // Word completion card
                    HStack(spacing: 22) {

                        // Checkmark button
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 55))
                                .foregroundColor(Color(hex: "8BC34A"))
                        }
                        .padding(.leading, 5)

                        // Word displayed RTL
                        Text(correctWord)
                            .font(.system(size: 52, weight: .medium))
                            .foregroundColor(.black)

                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                    }
                    .frame(width: 730, height: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
                    )
                } else {
                    // Coloring completion card - show the user's drawing
                    HStack(spacing: 30) {
                        // Checkmark button
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 55))
                                .foregroundColor(Color(hex: "8BC34A"))
                        }
                        
                        // Show the captured drawing or fallback to letter
                        if let drawingImage = drawingImage {
                            Image(uiImage: drawingImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Text(correctWord)
                                .font(.system(size: 120, weight: .bold))
                                .foregroundColor(Color(hex: "7B4D2C"))
                        }
                    }
                    .frame(width: 400, height: 180)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
                    )
                }

                Spacer()
            }
            .padding(.top, 40)
            
            // Confetti overlay
            if showConfetti {
                ConfettiView()
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
        .alert("ماذا تريد أن تفعل؟", isPresented: $showAlert) {
            Button("الحرف التالي") {
                navigationManager.goToNextLetter(currentLetter: currentLetter, activityType: activityType)
            }
            Button("العودة للرئيسية", role: .destructive) {
                navigationManager.goToHome()
            }
        }
    }
}
