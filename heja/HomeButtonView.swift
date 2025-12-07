import SwiftUI   // ← لازم يكون موجود

struct HomeButtonView: View {

    let title: String
    let imageName: String
    let color: String
    let action: () -> Void   // ← هذا اللي ينفذ عند الضغط

    var body: some View {
        VStack(spacing: 14) {

            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(hex: color))
                        .frame(width: 300, height: 300)
                        .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 4)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
            }

            Text(title)
                .font(.custom("NotoSansArabic-Regular", size: 26))
                .foregroundColor(Color(hex: "7B4D2C"))
        }
    }
}

