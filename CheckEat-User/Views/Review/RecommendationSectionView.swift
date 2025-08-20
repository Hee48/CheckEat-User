//
//  RecommendationSectionView.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//

import SwiftUI

struct RecommendationSectionView: View {
    @Binding var selectedRecommendation: MenuRecommendType
    @Binding var likeReasonText: String
    @Binding var dislikeReasonText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("review_recommend_menu_question")
                .semibold14()
                .padding(.top, 40)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 6) {
                    ForEach(MenuRecommendType.allCases) { type in
                        Button {
                            selectedRecommendation = type
                        } label: {
                            HStack {
                                Text(type.emoji)
                                Text(type.titleKey)
                            }
                            .medium14()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedRecommendation == type ? AnyView(Color.black) : AnyView(Color.gray.opacity(0.1)))
                            .foregroundColor(selectedRecommendation == type ? Color.white : Color.black)
                            .cornerRadius(20)
                        }
                    }
                }
            }
            .frame(height: 40)
            .padding(.top, 10)

            if selectedRecommendation == .dislike {
                TextFieldSection(title: "review_dislike_reason_required", text: $dislikeReasonText)
            } else if selectedRecommendation == .like {
                TextFieldSection(title: "review_like_reason_optional", text: $likeReasonText)
            }
        }
    }
}

private struct TextFieldSection: View {
    let title: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .semibold14()
                .foregroundColor(.black)
                .padding(.leading, 4)

            TextField(LocalizedStringKey("review_reason_placeholder"), text: $text)
                .regular14()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        }
        .padding(.top, 20)
    }
}
