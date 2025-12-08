//
//  LetterSelectionView.swift
//  hiajaa_challenge 3
//
//  Created by Danyah ALbarqawi on 02/12/2025.
//

import SwiftUI

struct LetterSelectionView: View {
    @StateObject private var viewModel: LetterSelectionViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    let activityType: ActivityType
    
    init(activityType: ActivityType) {
        self.activityType = activityType
        _viewModel = StateObject(wrappedValue: LetterSelectionViewModel(activityType: activityType))
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.2),
                    Color.pink.opacity(0.1),
                    Color.blue.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                LetterSelectionHeaderView(
                    onClose: { navigationManager.goBack() },
                    onToggleList: { viewModel.toggleListView() }
                )
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // Main Content
                if viewModel.showListView {
                    LetterSelectionListView(viewModel: viewModel)
                } else {
                    LetterSelectionSingleView(viewModel: viewModel)
                }
                
                Spacer()
                
                // Confirm Button
                LetterSelectionConfirmButton(
                    isEnabled: viewModel.isConfirmButtonEnabled,
                    text: viewModel.model.confirmButtonText,
                    action: {
                        if viewModel.activityType == .words {
                            navigationManager.navigateToWordView(letter: viewModel.selectedLetter)
                        } else {
                            navigationManager.navigateToColoringView(letter: viewModel.selectedLetter)
                        }
                    }
                )
                .padding(.horizontal, 40)
                
                // Instruction Text
                Text(viewModel.showListView ? viewModel.model.listInstruction : viewModel.model.swipeInstruction)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
    }
}
