//
//  WordView.swift
//  hiajaa_challenge 3
//
//  Created by najd aljarba on 16/06/1447 AH.
//

import SwiftUI

struct WordView: View {

    let model: WordModel
    @Binding var selectedAvatar: String

    @State private var goToSpelling = false

    var body: some View {

        VStack(spacing: 50) {

            // ------- كرت الحيوان بنفس ستايل Figma -------
            ZStack {
                RoundedRectangle(cornerRadius: 45)
                    .fill(Color(hex: "FFE5C4"))
                    .frame(width: 480, height: 550)
                    .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: 6)

                VStack(spacing: 25) {

                    // أيقونة الصوت
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.15), radius: 4)

                    // صورة الحيوان
                    Image(model.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)

                    // مربعات الديكور الثلاثة
                    HStack(spacing: 28) {
                        decoBox(color: "FFB5B5")
                        decoBox(color: "B5FFD6")
                        decoBox(color: "E8B5FF")
                    }
                }
            }

            // ************* زر ابدأ *************
            Button {
                goToSpelling = true
            } label: {
                Text("ابدأ")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 260, height: 70)
                    .background(Color(hex: "A7D54E"))
                    .cornerRadius(40)
                    .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
            }
        }
        .navigationDestination(isPresented: $goToSpelling) {
            SpellingView(model: model, selectedAvatar: $selectedAvatar)
        }
    }

    // صندوق ديكور مطابق لفجما
    func decoBox(color: String) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color(hex: color), lineWidth: 4)
            .background(
                RoundedRectangle(cornerRadius: 16).fill(.white)
            )
            .frame(width: 70, height: 70)
    }
}
