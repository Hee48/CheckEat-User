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
            Text("메뉴를 추천하시나요?")
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
                                Text(type.rawValue)
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
                TextFieldSection(title: "추천 하고 싶지 않은 이유를 알려주세요(필수)", text: $dislikeReasonText)
            } else if selectedRecommendation == .like {
                TextFieldSection(title: "추천 하고 싶은 이유를 알려주세요(선택)", text: $likeReasonText)
            }
        }
    }
}

private struct TextFieldSection: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .semibold14()
                .foregroundColor(.black)
                .padding(.leading, 4)

            TextField("간단히 작성", text: $text)
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
