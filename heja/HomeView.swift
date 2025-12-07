import SwiftUI

struct HomeView: View {

    let avatar: Avatar
    @Environment(\.dismiss) var dismiss

    @State private var goToWord = false
    @State private var selectedAvatar: String = ""   // ← هذا اللي نمرره لكل الصفحات

    // كلمة واحدة مؤقتاً (lion)
    let model = WordModel(
        word:"Lion", imageName: "lion", title: "Lion",
        letters: ["l", "i", "o", "n"]
    )

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? "Good Morning" : "Good Evening"
    }

    var body: some View {
        NavigationStack {

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
                        selectedAvatar = avatar.image   // ← نحدد شخصية المستخدم
                        goToWord = true
                    }

                    HomeButtonView(
                        title: "Coloring",
                        imageName: "coloringIcon",
                        color: "BAE9FA"
                    ) { }
                }
                .padding(.top, 100)

                Spacer()
            }

            .background(Color(hex: "FEFEFE"))
            .ignoresSafeArea()

            //------------------
            // NAVIGATION
            //------------------
            .navigationDestination(isPresented: $goToWord) {
                WordView(model: model, selectedAvatar: selectedAvatar)
            }
        }
    }
}
