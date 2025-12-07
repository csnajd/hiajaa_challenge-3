import SwiftUI
import UniformTypeIdentifiers

struct WordView: View {
    
    @StateObject private var viewModel: WordViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    let selectedLetter: String
    
    init(selectedLetter: String = "A") {
        self.selectedLetter = selectedLetter
        _viewModel = StateObject(wrappedValue: WordViewModel(selectedLetter: selectedLetter))
    }
    
    // Slot border colors
    private let slotBorderColors: [Color] = [
        Color(red: 1.0, green: 0.50, blue: 0.50),   // red
        Color(red: 0.50, green: 0.90, blue: 0.60),  // green
        Color(red: 0.85, green: 0.65, blue: 1.0)    // purple
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                // Back button top left
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
                }
                .padding(.leading, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Main beige card
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 1.0, green: 0.93, blue: 0.80))
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    
                    VStack(spacing: 24) {
                        
                        // Sound button at top
                        HStack {
                            Spacer()
                            Button {
                                // Play sound here
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.title2.bold())
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(Color.yellow)
                                            .shadow(radius: 4)
                                    )
                            }
                            Spacer()
                        }
                        .padding(.top, 24)
                        
                        // Image from currentPuzzle
                        if let puzzle = viewModel.currentPuzzle {
                            Image(puzzle.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                        }
                        
                        // Letter slots (targetSlots)
                        HStack(spacing: 18) {
                            ForEach(0..<viewModel.currentWord.count, id: \.self) { index in
                                let letter = viewModel.getLetterAt(position: index)
                                let borderColor = slotBorderColors[index % slotBorderColors.count]
                                
                                TargetSlotView(letter: letter, borderColor: borderColor)
                                    .onTapGesture {
                                        viewModel.removeLetter(at: index)
                                    }
                                    .onDrop(of: [UTType.plainText], isTargeted: nil) { providers in
                                        handleDrop(providers: providers, at: index)
                                    }
                            }
                        }
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Letters below the card (from getAvailableLetters)
                HStack(spacing: 40) {
                    ForEach(viewModel.getAvailableLetters()) { letter in
                        LetterTileView(letter: letter,
                                       isShaking: viewModel.isLetterShaking(letter))
                            .onDrag {
                                let provider = NSItemProvider(object: letter.id.uuidString as NSString)
                                return provider
                            }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .navigationBarHidden(true)
        // Page shake effect on error
        .modifier(PageShakeEffect(shakes: viewModel.shakePage ? 1 : 0))
        .animation(.easeInOut(duration: 0.25), value: viewModel.shakePage)
        .onAppear {
            if viewModel.currentPuzzle == nil {
                viewModel.selectLetter(viewModel.selectedLetter.isEmpty ? "A" : viewModel.selectedLetter)
            }
        }
        .onChange(of: viewModel.showSuccessView) { _, newValue in
            if newValue {
                let data = SuccessData(
                    selectedAvatar: "avatar1",
                    correctWord: viewModel.currentWord.uppercased(),
                    imageName: viewModel.currentPuzzle?.imageName ?? "",
                    activityType: .words,
                    currentLetter: selectedLetter
                )
                navigationManager.navigateToSuccess(data: data)
                viewModel.showSuccessView = false
            }
        }
    }
    
    // MARK: - Drop handling
    
    private func handleDrop(providers: [NSItemProvider], at position: Int) -> Bool {
        guard let provider = providers.first else { return false }
        
        provider.loadObject(ofClass: NSString.self) { object, _ in
            guard let idString = object as? String,
                  let uuid = UUID(uuidString: idString) else { return }
            
            if let letter = viewModel.letters.first(where: { $0.id == uuid }) {
                DispatchQueue.main.async {
                    viewModel.dropLetter(letter, at: position)
                }
            }
        }
        return true
    }
}

// MARK: - Target Slot View

struct TargetSlotView: View {
    let letter: Letter?
    let borderColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(borderColor, lineWidth: 3)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.4))
                )
                .frame(width: 55, height: 55)
            
            if let letter = letter {
                Text(letter.character)
                    .font(.title.bold())
                    .foregroundColor(.black)
            }
        }
    }
}

// MARK: - Letter Tile View

struct LetterTileView: View {
    let letter: Letter
    let isShaking: Bool
    
    var body: some View {
        Text(letter.character)
            .font(.title.bold())
            .foregroundColor(.black)
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(letter.color)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
            )
            .modifier(ShakeEffect(shakes: isShaking ? 2 : 0))
            .animation(.default, value: isShaking)
    }
}

// MARK: - Shake Effect for Letter

struct ShakeEffect: GeometryEffect {
    var shakes: Int
    var amplitude: CGFloat = 8
    
    var animatableData: CGFloat {
        get { CGFloat(shakes) }
        set { shakes = Int(newValue) }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * 2) * amplitude
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - Page Shake Effect

struct PageShakeEffect: GeometryEffect {
    var shakes: CGFloat = 0
    var amplitude: CGFloat = 10
    
    var animatableData: CGFloat {
        get { shakes }
        set { shakes = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(shakes * .pi * 2) * amplitude
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - Preview

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(selectedLetter: "A")
            .previewDevice("iPad (10th generation)")
    }
}
