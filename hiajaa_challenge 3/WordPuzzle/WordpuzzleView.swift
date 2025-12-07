import SwiftUI
import UniformTypeIdentifiers

struct WordView: View {
    
    @StateObject private var viewModel: WordViewModel
    
    // لو تبين تمررين حرف معيّن من شاشة سابقة
    init(selectedLetter: String = "أ") {
        _viewModel = StateObject(wrappedValue: WordViewModel(selectedLetter: selectedLetter))
    }
    
    // ألوان حدود الخانات (زي التصميم حقك)
    private let slotBorderColors: [Color] = [
        Color(red: 1.0, green: 0.50, blue: 0.50),   // red
        Color(red: 0.50, green: 0.90, blue: 0.60),  // green
        Color(red: 0.85, green: 0.65, blue: 1.0)    // purple
    ]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                // زر رجوع يسار فوق
                HStack {
                    Button {
                        // رجوع لو عندك NavigationStack
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
                
                // الكرت الأساسي البيج (يغطي نص الشاشة)
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 1.0, green: 0.93, blue: 0.80))
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    
                    VStack(spacing: 24) {
                        
                        // زر الصوت / المايك فوق
                        HStack {
                            Spacer()
                            Button {
                                // شغّلي الصوت هنا
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
                        
                        // صورة الحيوان من currentPuzzle
                        if let puzzle = viewModel.currentPuzzle {
                            Image(puzzle.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                        }
                        
                        // خانات الحروف (targetSlots)
                        HStack(spacing: 18) {
                            ForEach(0..<viewModel.currentWord.count, id: \.self) { index in
                                let letter = viewModel.getLetterAt(position: index)
                                let borderColor = slotBorderColors[index % slotBorderColors.count]
                                
                                TargetSlotView(letter: letter, borderColor: borderColor)
                                    .onTapGesture {
                                        viewModel.removeLetter(at: index)
                                    }
                                    // 👇 نوع الداتا اللي نستقبلها من السحب
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
                .frame(height: UIScreen.main.bounds.height * 0.5)  // ← يغطي نص الشاشة
                .padding(.horizontal, 20)
                
                Spacer()
                
                // الحروف تحت الكرت (من getAvailableLetters)
                HStack(spacing: 40) {
                    ForEach(viewModel.getAvailableLetters()) { letter in
                        LetterTileView(letter: letter,
                                       isShaking: viewModel.isLetterShaking(letter))
                            // 👇 هنا نرسل الـ id كنص عشان نلقاه في الـ drop
                            .onDrag {
                                let provider = NSItemProvider(object: letter.id.uuidString as NSString)
                                return provider
                            }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        // اهتزاز الصفحة إذا حصل خطأ
        .modifier(PageShakeEffect(shakes: viewModel.shakePage ? 1 : 0))
        .animation(.easeInOut(duration: 0.25), value: viewModel.shakePage)
        .onAppear {
            if viewModel.currentPuzzle == nil {
                viewModel.selectLetter(viewModel.selectedLetter.isEmpty ? "أ" : viewModel.selectedLetter)
            }
        }
    }
    
    // MARK: - Drop handling
    
    private func handleDrop(providers: [NSItemProvider], at position: Int) -> Bool {
        guard let provider = providers.first else { return false }
        
        // 👇 نستقبل نفس النوع اللي أرسلناه (NSString / plainText)
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

// MARK: - خانة من الخانات (المربعات فوق)

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

// MARK: - المربعات اللي تحت (الحروف)

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

// MARK: - تأثير الاهتزاز للحرف

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

// MARK: - تأثير اهتزاز الصفحة / الكرت كامل

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

struct WordpuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(selectedLetter: "أ")
            .previewDevice("iPad (10th generation)")
    }
}
