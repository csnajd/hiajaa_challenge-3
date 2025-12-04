//
import SwiftUI
import UniformTypeIdentifiers

struct WordpuzzleView: View {

    @StateObject private var viewModel: WordPuzzleViewModel

    // لو تبين تمررين حرف معيّن من شاشة سابقة
    init(selectedLetter: String = "أ") {
        _viewModel = StateObject(wrappedValue: WordPuzzleViewModel(selectedLetter: selectedLetter))
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

                // الكرت الأساسي
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 1.0, green: 0.93, blue: 0.80))
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)

                    VStack(spacing: 18) {

                        // صورة الحيوان من currentPuzzle
                        if let puzzle = viewModel.currentPuzzle {
                            Image(puzzle.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                                .padding(.top, 24)
                        }

                        // زر الصوت
                        Button {
                            // شغلي الصوت هنا
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title3.bold())
                                .foregroundColor(.black)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.yellow)
                                        .shadow(radius: 4)
                                )
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
                                    .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers, at: index)
                                    }
                            }
                        }
                        .padding(.bottom, 28)
                    }
                    .padding(.horizontal, 32)
                }
                .frame(height: 430)
                .padding(.horizontal, 40)

                Spacer()

                // الحروف تحت الكرت (من getAvailableLetters)
                HStack(spacing: 40) {
                    ForEach(viewModel.getAvailableLetters()) { letter in
                        LetterTileView(letter: letter,
                                       isShaking: viewModel.isLetterShaking(letter))
                            .onDrag {
                                NSItemProvider(object: letter.id.uuidString as NSString)
                            }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            if viewModel.currentPuzzle == nil {
                viewModel.selectLetter(viewModel.selectedLetter.isEmpty ? "أ" : viewModel.selectedLetter)
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

// MARK: - خانة من الخانات الثلاث

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

// MARK: - تأثير الاهتزاز

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

// MARK: - Preview

struct WordpuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        WordpuzzleView(selectedLetter: "أ")
            .previewDevice("iPad (10th generation)")
    }
}
