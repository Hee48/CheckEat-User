//
//  ReviewPendingListView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/27/25.
//

import SwiftUI


struct PendingReview: Identifiable {
    let id = UUID()
    let storeName: String
}

struct ReviewPendingListView: View {
    let dummyReviews: [PendingReview] = [
        PendingReview(storeName: "홍콩반점"),
        PendingReview(storeName: "고등어구이전문점"),
        PendingReview(storeName: "아비꼬")
    ]
    @State private var showAddReivew = false
    
    var body: some View {
        GeometryReader { containerGeo in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(dummyReviews) { review in
                        HStack(alignment: .top, spacing: 12) {
                            ZStack {
                                Rectangle()
                                    .fill(Color("Button_OP20"))
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .frame(width: 40, height: 30)
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .padding(20)
                            }
                            .frame(width: 95, height: 95) 
                            .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(review.storeName)
                                    .bold18()
                                Text("리뷰를 등록해주세요.")
                                    .medium16()
                                    .foregroundColor(Color("Button_OP50"))
                                    .padding(.top, 10)
                            }
                            .padding(.top, 20)
                            
                            Spacer()
                            
                            Button {
                               showAddReivew = true
                            } label: {
                                Image("arrow.right")
                    
                            }
                            .padding(.top, 30)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                }
                .fullScreenCover(isPresented: $showAddReivew) {
                    AddReivewView()
                }
            }
        }
    }
}

#Preview {
    ReviewPendingListView()
}
