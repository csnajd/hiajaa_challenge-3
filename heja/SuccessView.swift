import SwiftUI

struct SuccessView: View {

    let selectedAvatar: String
    let correctWord: String
    let imageName: String

    var body: some View {

        VStack(spacing: 32) {

            // العنوان
            Text("Exellent!")
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(Color(hex: "CE845A"))

            Text("Good job⭐️")
                .font(.system(size: 26))
                .foregroundColor(.black.opacity(0.75))


            // ---------------------------
            // الخلفية المقصوصة + الأفاتار
            // ---------------------------
            ZStack {

                // الخلفية - أكبر وبشكل مضبوط
                Image("success_bg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 750)       // ← هذا هو الحجم الصحيح لفقما
                    .offset(y: -20)          // رفع بسيط عشان تتوازن في الشاشة

                // الأفاتار داخل الدائرة
                Image(selectedAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)       // مناسب بحيث ما يغطي النجوم
                    .offset(y: -90)
            }
            .padding(.top, 10)



            // ---------------------------
            // الكرت — مطابق تمامًا لفقما
            // ---------------------------
            HStack(spacing: 22) {

                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)

                HStack(spacing: 18) {
                    ForEach(Array(correctWord), id: \.self) { letter in
                        Text(String(letter))
                            .font(.system(size: 52, weight: .medium))
                            .foregroundColor(.black)
                    }
                }

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 55))
                    .foregroundColor(Color(hex: "8BC34A"))
                    .padding(.trailing, 5)
            }
            .frame(width: 730, height: 160)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
            )
            .padding(.top, 10)

            Spacer()
        }
        .padding(.top, 40)
        .background(Color.white.ignoresSafeArea())
    }
}
