//
//  StoreMenuCellView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct StoreMenuCellView: View {
    let menu: Food
    let onReviewTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: menu.foo_img ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 70)
                        .cornerRadius(8)
                } placeholder: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.buttonOP)
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.buttonEnable)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(menu.foo_name)
                            .semibold18()
                        Spacer()
                        Text("비건 단계 표시")
                    }
                    HStack {
                        Text("\(menu.foo_price)원")
                            .semibold16()
                            .padding(.bottom, 4)
                        Spacer()
                        Button(action: onReviewTap) {
                            HStack {
                                Text("리뷰")
                                    .foregroundStyle(.black)
                                Image(systemName: "chevron.forward")
                                    .resizable()
                                    .frame(width: 6, height: 9)
                                    .foregroundStyle(.buttonOP50)
                            }
                            .regular12()
                        }
                    }
                    HStack(spacing: 2) {
                        Image("Warn")
                            .foregroundStyle(.buttonOP50)
                        Text("알레르기")
                            .foregroundStyle(.buttonOP50)
                            .padding(.trailing, 6)
                        Text(menu.foo_material ?? "위험한 유발 요인 없읍")
                            .foregroundStyle(.red)
                    }
                }
                .regular14()
            }
            .padding(.vertical, 2)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            Divider()
        }
    }
}
