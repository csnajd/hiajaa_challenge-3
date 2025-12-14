import SwiftUI

struct HomeView: View {

    let avatar: Avatar
    @EnvironmentObject var navigationManager: NavigationManager

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 12 ? "صباح الخير" : "مساء الخير"
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            //------------------
            // المحتوى الأساسي
            //------------------
            VStack(spacing: 0) {

                // HEADER
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
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(Color(hex: "7B4D2C"))
                    }
                }

                Spacer().frame(height: 40)

                // BUTTONS
                HStack(spacing: 150) {

                    HomeButtonView(
                        title: "",
                        imageName: "wordsIcon",
                        color: "CBFABA"
                    ) {
                        navigationManager.navigateToLetterSelection(activityType: .words)
                    }

                    HomeButtonView(
                        title: "",
                        imageName: "coloringIcon",
                        color: "BAE9FA"
                    ) {
                        navigationManager.navigateToLetterSelection(activityType: .coloring)
                    }
                }
                .padding(.top, 100)

                Spacer()
            }

            //------------------
            // زر الرجوع لاختيار الصورة
            //------------------
            Button {
                navigationManager.goToAvatarSelection()
            } label: {
                Image(systemName: "arrow.backward.circle.fill")
                    .font(.system(size: 38))
                    .foregroundColor(Color(hex: "7B4D2C"))
                    .padding(.top, 40)
                    .padding(.leading, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "FEFEFE"))
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
