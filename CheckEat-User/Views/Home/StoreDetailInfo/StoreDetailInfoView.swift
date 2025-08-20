//
//  StoreDetailInfoView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

import SwiftUI

struct StoreDetailInfoView: View {
    
    // 목록에서 선택된 가게 ID와 사용자 설정 언어
    let storeId: Int
    let language: String
    
    @StateObject private var viewModel = StoreDetailInfoViewModel()
    
    // 숨김 필드 보여주기 (좌표)
    @State var showLocationField: Bool = false
    // 전체 운영 보여주기 (러닝타임)
    @State var showRunningTimeField: Bool = false
    // 탭 선택 상태
    @State var selectedTab: String = "전체메뉴"
    
    var body: some View {
        GeometryReader { geo in
            //MARK: 가게 상세정보 로딩 상태
            if viewModel.isLoading {
                //MARK: 네트워크 통신 이후 데이터를 아직 가져오지 못 한 경우...
                ProgressView {
                    Text("")
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // 에러 상태
            else if let errorMessage = viewModel.errorMessage {
                //TODO: 에러 상태 어떻게 처리할지 고민해보시게나
            }
            //MARK: - 가게 상세정보 가져오기 Success
            else if let storeInfo = viewModel.storeDetailInfo {
                ScrollView {
                    VStack {
                        // 상단 이미지
                        ZStack {
                            Rectangle()
                                .fill(.buttonSoft)
                                .frame(maxWidth: .infinity, minHeight: geo.size.height * 0.3)
                            AsyncImage(url: URL(string: storeInfo.sto_img ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height * 0.3)
                                    .clipped()
                            } placeholder: {
                                Image(systemName: "storefront.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.buttonEnable)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            // 가게명과 즐겨찾기 버튼
                            StoreHeaderSection(storeId: storeId, storeInfo: storeInfo)
                                .environmentObject(viewModel)
                            
                            if storeInfo.sto_halal == 1 {
                                HStack(spacing: 4) {
                                    Text("할랄 인증 업소")
                                        .foregroundColor(.white)
                                        .semibold14()
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .background(.correct)
                                        .cornerRadius(15)
                                }
                                .regular14()
                                .padding(.bottom, 8)
                            }
                            
                            // 주소와 좌표
                            StoreLocationSection(storeInfo: storeInfo, showLocationField: $showLocationField)
                            
                            // 영업시간, 공휴일, 가게 전화번호
                            CoreDataSection(storeInfo: storeInfo, showRunningTimeField: $showRunningTimeField)
                        }
                        .padding(.horizontal)
                    }
                    .regular16()
                    
                    // 메뉴 구분선
                    Rectangle()
                        .fill(Color("Button_OP20"))
                        .frame(height: 1)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    
                    // 메뉴 섹션
                    StoreMenuSection(storeInfo: storeInfo, selectedTab: $selectedTab)
                }
            }
            //MARK: 네트워크 통신 지연 등의 이슈로 인한 초기 세팅
            else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .onAppear {
            if viewModel.storeDetailInfo == nil {
                viewModel.loadStoreDetailInfo(storeId: storeId, language: language)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showLoginView) {
            LoginView()
        }
    }
}
