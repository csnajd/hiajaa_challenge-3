import SwiftUI
import UniformTypeIdentifiers

struct SpellingView: View {

    let model: WordModel
    @Binding var selectedAvatar: String
    @EnvironmentObject var navigationManager: NavigationManager

    @State private var letters: [String] = []
    @State private var placed: [String?] = []
    @State private var goToSuccess = false
    @State private var wrongShake = false

    let colors = ["FFB5B5","B5FFD6","E8B5FF","FFF5AD"]

    var boxColors: [Color] {
        model.word.map { _ in
            Color(hex: colors.randomElement()!)
        }
    }

    var body: some View {

        VStack(spacing: 30) {

            // Card
            ZStack {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color(hex: "FFE5C4"))
                    .frame(width: 480, height: 550)
                    .shadow(color: .black.opacity(0.12), radius: 18)

                VStack(spacing: 20) {

                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                        .shadow(radius: 3)

                    Image(model.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260)

                    HStack(spacing: 25) {
                        ForEach(0..<model.word.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.7))
                                .frame(width: 55, height: 55)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(boxColors[i], lineWidth: 3)
                                )
                        }
                    }
                }
            }

            // Letter boxes
            HStack(spacing: 25) {

                ForEach(0..<placed.count, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.12), radius: 6)

                        if let l = placed[index] {
                            Text(l)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    .modifier(ShakeEffect(shakes: wrongShake ? 2 : 0))
                    .onDrop(of: [.text], isTargeted: nil) { providers in
                        handleDrop(providers: providers, index: index)
                        return true
                    }
                }
            }

            // Letters below
            HStack(spacing: 25) {
                ForEach(letters, id: \.self) { letter in
                    if !placed.contains(letter) {
                        Text(letter)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .background(Color(hex: colors.randomElement()!))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.15), radius: 6)
                            .onDrag { NSItemProvider(object: letter as NSString) }
                    }
                }
            }
        }
        .padding(.top, 40)
        .onAppear { setupBoard() }
        .onChange(of: goToSuccess) { _, newValue in
            if newValue {
                let firstLetter = String(model.word.prefix(1)).uppercased()
                let data = SuccessData(
                    selectedAvatar: selectedAvatar,
                    correctWord: model.word,
                    imageName: model.imageName,
                    activityType: .words,
                    currentLetter: firstLetter
                )
                navigationManager.navigateToSuccess(data: data)
                goToSuccess = false
            }
        }
    }

    // --- Functions ---

    func setupBoard() {
        let chars = model.word.map { String($0) }
        letters = chars.shuffled()
        placed = Array(repeating: nil, count: chars.count)
    }

    func handleDrop(providers: [NSItemProvider], index: Int) {
        providers.first?.loadItem(forTypeIdentifier: "public.text", options: nil) { data, _ in
            if let data = data as? Data,
               let letter = String(data: data, encoding: .utf8) {

                DispatchQueue.main.async {
                    if letter == String(model.word[model.word.index(model.word.startIndex, offsetBy: index)]) {
                        placed[index] = letter
                        checkIfDone()
                    } else {
                        wrongShake.toggle()
                    }
                }
            }
        }
    }

    func checkIfDone() {
        if placed.compactMap({ $0 }).joined() == model.word {
            goToSuccess = true
        }
    }
}
