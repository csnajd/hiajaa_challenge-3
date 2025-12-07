import SwiftUI

struct HomeView: View {

    let avatar: Avatar
    @StateObject private var navigationManager = NavigationManager()

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? "Good Morning" : "Good Evening"
    }

    var body: some View {
        NavigationStack(path: $navigationManager.path) {

            VStack(spacing: 0) {

                //------------------
                // HEADER
                //------------------
                ZStack {
                    Color(hex: "FFEDA4")
                        .frame(width: 850, height: 498)
                        .shadow(color: Color.black.opacity(0.10), radius: 18)
                        .ignoresSafeArea()

                    VStack(spacing: 12) {

                        ZStack {
                            Circle()
                                .fill(Color(hex: "FFB987"))
                                .frame(width: 199, height: 193)
                                .shadow(color: Color.black.opacity(0.15), radius: 10)

                            Image(avatar.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 226, height: 226)
                        }

                        Text(greeting)
                            .font(.custom("NotoSansArabic-Regular", size: 40))
                            .foregroundColor(Color(hex: "7B4D2C"))
                    }
                }

                Spacer().frame(height: 40)

                //------------------
                // BUTTONS
                //------------------
                HStack(spacing: 150) {

                    HomeButtonView(
                        title: "Words",
                        imageName: "wordsIcon",
                        color: "CBFABA"
                    ) {
                        navigationManager.navigateToLetterSelection(activityType: .words)
                    }

                    HomeButtonView(
                        title: "Coloring",
                        imageName: "coloringIcon",
                        color: "BAE9FA"
                    ) {
                        navigationManager.navigateToLetterSelection(activityType: .coloring)
                    }
                }
                .padding(.top, 100)

                Spacer()
            }

            .background(Color(hex: "FEFEFE"))
            .ignoresSafeArea()

            //------------------
            // NAVIGATION DESTINATIONS
            //------------------
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .letterSelection(let activityType):
                    LetterSelectionView(activityType: activityType)
                        .environmentObject(navigationManager)
                case .wordView(let letter):
                    WordView(selectedLetter: letter)
                        .environmentObject(navigationManager)
                case .coloringView(let letter):
                    ColoringView(selectedLetter: letter)
                        .environmentObject(navigationManager)
                case .successView(let data):
                    SuccessView(
                        selectedAvatar: data.selectedAvatar,
                        correctWord: data.correctWord,
                        imageName: data.imageName,
                        activityType: data.activityType,
                        currentLetter: data.currentLetter,
                        // 👇 ADDED THIS BLOCK to match SuccessView definition
                        onNextLetter: {
                            navigationManager.goToNextLetter(currentLetter: data.currentLetter, activityType: data.activityType)
                        }
                    )
                    .environmentObject(navigationManager)
                }
            }
        }
    }
}
