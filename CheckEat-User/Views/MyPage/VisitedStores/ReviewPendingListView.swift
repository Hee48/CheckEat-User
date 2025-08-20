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
    @ObservedObject var viewModel: VisitedStoreViewModel
    @State private var selectedStoreId: Int? = nil
    @State private var showCheckModal = false
    @State private var reviewPath: [ReviewPath] = []
    @State private var isReviewFlowActive = false
    
    var body: some View {
        GeometryReader { containerGeo in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.unreviewedStores) { store in
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
                                Text(store.sto_name)
                                    .bold18()
                                Text("review_request_register".localized)
                                    .medium16()
                                    .foregroundColor(Color("Button_OP50"))
                                    .padding(.top, 10)
                            }
                            .padding(.top, 20)
                            
                            Spacer()
                            
                            Button {
                                selectedStoreId = store.sto_id
                                print("👉 선택된 sto_id:", store.sto_id)
                            } label: {
//                                Image("arrow.right")
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
                .fullScreenCover(item: $selectedStoreId) { storeId in
                    AddReivewView(
                        isPresented: Binding(
                            get: { selectedStoreId != nil },
                            set: { if !$0 { selectedStoreId = nil } }
                        ),
                        showCheckModal: $showCheckModal,
                        reviewPath: $reviewPath,
                        isReviewFlowActive: $isReviewFlowActive,
                        storeId: storeId
                    )
                }
            }
            .onAppear {
                viewModel.pendingReviewStores()
            }
        }
    }
}

