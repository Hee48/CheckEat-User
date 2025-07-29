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
    let segments = ["리뷰작성", "리뷰미작성"]
    @State private var selectedMenuIndex: Int? = nil
    @State private var showMenu: Bool = false
    @State private var anchorFrame: CGRect = .zero
    var body: some View {
        NavigationStack {
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
                        ReviewCompletedListView()
                    } else {
                        // 리뷰 미작성 가게 리스트
                        ReviewPendingListView()
                    }
                }
                .padding(.top, 20)
                Spacer()

            }
            .navigationTitle("이용한 가게")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}
#Preview {
    VisitedStores()
}
