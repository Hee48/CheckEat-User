//
//  MyPageHeaderView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/16/25.
//

import SwiftUI

struct MyPageHeaderView: View {
    
    let nickName: String
    let userEmail: String
    @Binding var showMoreMenu: Bool
    @Binding var showManageCompanyModal: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                showManageCompanyModal = true
            } label: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 10)
            }
            .foregroundStyle(.primary)
//            .sheet(isPresented: $showManageCompanyModal) {
//                ManageCompanyModalView()
//                    .presentationDragIndicator(.visible)
//                    .presentationDetents([.height(350)])
//            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text(nickName).bold20()
                    
                    Spacer()
                    Button {
                        withAnimation { showMoreMenu.toggle() }
                    } label: {
                        Image("More")
                    }
                }
                
                Text(userEmail)
                    .regular16()
                    .foregroundColor(.buttonAuth)
            }
        }
        .padding(.vertical, 35)
        .padding(.horizontal)
    }
}
