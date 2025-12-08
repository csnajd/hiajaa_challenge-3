//
//  AvatarSelectionView.swift
//  hiajaa_challenge 3
//
//  Created by najd aljarba on 16/06/1447 AH.
//
import SwiftUI

struct Avatar: Identifiable {
    let id = UUID()
    let image: String
}

let avatars: [Avatar] = [
    Avatar(image: "avatar1"),
    Avatar(image: "avatar2"),
    Avatar(image: "avatar3"),
    Avatar(image: "avatar4")
]

struct AvatarSelectionView: View {
    @State private var selectedAvatar: Avatar? = nil
    @StateObject private var navigationManager = NavigationManager()

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            
            VStack(spacing: 0) {

                Text("Choose your character")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.top, 40)

                Spacer().frame(height: 40)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 60),
                        GridItem(.flexible(), spacing: 60)
                    ],
                    spacing: 120
                ) {

                    ForEach(avatars) { avatar in
                        ZStack {
                            Circle()
                                .fill(Color("q1"))
                                .frame(width: 257, height: 243)

                            Image(avatar.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 204, height: 250)
                        }
                        .overlay(
                            Circle()
                                .stroke(selectedAvatar?.id == avatar.id ? Color.green : .clear, lineWidth: 8)
                        )
                        .onTapGesture {
                            selectedAvatar = avatar
                        }
                    }
                }

                Spacer().frame(height: 95)

                Button(action: {
                    if selectedAvatar != nil {
                        navigationManager.path.append("home")
                    }
                }) {
                    Text("Confirm")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 344, height: 82)
                        .background(Color(hex: "97C331"))
                        .cornerRadius(40)
                }
                .opacity(selectedAvatar == nil ? 0.4 : 1)
                .disabled(selectedAvatar == nil)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "FEFEFE"))

            // Navigation destinations
            .navigationDestination(for: String.self) { destination in
                if destination == "home", let avatar = selectedAvatar {
                    HomeView(avatar: avatar)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(navigationManager)
                }
            }
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
                        currentLetter: data.currentLetter
                    )
                    .environmentObject(navigationManager)
                }
            }
        }
    }
}

// MARK: - Preview

struct AvatarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarSelectionView()
            .previewDevice("iPad (10th generation)")
    }
}
