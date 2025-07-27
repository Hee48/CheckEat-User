//
//  FoodReviewView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/27/25.
//

import SwiftUI

struct FoodReviewView: View {
    
    @ObservedObject var viewModel: FoodReviewViewModel
    let foodId: Int
    let stores: [Store]
    @State var foodName: String = ""
    @State private var storeName: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if foodId < 0 {
                    Text("⚠️ 유효하지 않은 메뉴 정보입니다.")
                    Text("리뷰를 불러올 수 없습니다. 다시 시도해 주세요.")
                } else {
                    let reviews = viewModel.reviews(for: foodId)
                    
                    if reviews.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("\(foodName) 리뷰")
                                .bold20()
                                .padding(.bottom)
                            HStack {
                                Spacer()
                                Text("등록된 리뷰가 없습니다.")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .padding(.vertical, 150)
                            //FIXME: 화면 크기에 따른 센터 정렬
                        }
                        .padding(.horizontal)
                    } else {
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("\(foodName) 리뷰")
                                        .bold20()
                                        .padding(.bottom)
                                    ForEach(reviews) { review in
                                        VStack {
                                            HStack(alignment: .top, spacing: 12) {
                                                AsyncImage(url: URL(string: review.revi_img ?? "")) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: 70)
                                                        .cornerRadius(8)
                                                } placeholder: {
                                                    ProgressView()
                                                        .frame(width: 70, height: 70)
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("리뷰어")
                                                        .bold20()
                                                        .padding(.bottom, 2)
                                                    switch review.revi_reco_step {
                                                    case 0 : Text("😋 추천하고 싶어요 ")
                                                    case 1 : Text("🙂 별 생각 없어요")
                                                    case 2 : Text("😒 추천하고 싶지 않아요")
                                                    default : Text("로딩 중...")
                                                    }
                                                    Text(review.revi_content ?? "코멘트가 달리지 않은 리뷰입니다.")
                                                        .foregroundColor(.secondary)
                                                }
                                                .regular14()
                                                
                                            }
                                        }
                                        Divider()
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, -20)
            .onAppear {
                foodName = viewModel.foodName(for: foodId) ?? "(메뉴 불러오는 중)"
                storeName = viewModel.storeName(for: foodId, from: stores) ?? "(가게 정보 없음)"
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(storeName)
                        .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                }
            }
        }
    }
}
