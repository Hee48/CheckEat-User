//
//  CreateReview .swift
//  CheckEat-User
//
//  Created by Hee  on 7/27/25.
//

import SwiftUI

struct VisitedStores: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedIndex: Int = 0
    let segments = ["segment_review_written".localized, "segment_review_pending".localized]
    @State private var selectedMenuIndex: Int? = nil
    @State private var showMenu: Bool = false
    @State private var anchorFrame: CGRect = .zero
    @StateObject private var reviewCompletedViewModel = VisitedStoreViewModel()
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 0) {
                    SegmentedControl(segments: segments, selectedIndex: $selectedIndex)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                }
                
                if selectedIndex == 0 {
                    // 리뷰 작성된 가게 리스트
                    ReviewCompletedListView(viewModel: reviewCompletedViewModel)
                } else {
                    // 리뷰 미작성 가게 리스트
                    ReviewPendingListView(viewModel: reviewCompletedViewModel)
                }
            }
            .padding(.top, 20)
            Spacer()
            
        }
        .navigationTitle("visited_stores_title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            reviewCompletedViewModel.fetchReviewedStores()
            reviewCompletedViewModel.pendingReviewStores()
        }
    }
}
//#Preview {
//    VisitedStores()
//}
