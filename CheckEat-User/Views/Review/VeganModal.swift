//
//  VeganModal.swift
//  CheckEat-User
//
//  Created by Hee  on 7/26/25.
//

import SwiftUI

struct VeganModal: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Text("비건 구분")
                .bold20()
                .padding(.top, 10)
            Text("섭취하는 음식의 범위에 따라 비건 구분이 달라집니다.")
                .padding(.top, 10)
            Text("비건: 동물성 식품 전부 섭취 금지")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.1686, green: 0.4784, blue: 0.4196))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Vegan"))
                )
                .padding(.top, 10)
            Text("락토: 유제품 허용, 달걀은 금지")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.4784, green: 0.451, blue: 0.1725))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Lacto"))
                )
            Text("오보: 달걀 허용, 유제품은 금지")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.3725, green: 0.2941, blue: 0.5451))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Ovo"))
                )
            Text("락토 오보: 유제품과 달걀 허용")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.2039, green: 0.4941, blue: 0.5804))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Lacto-ovo"))
                )
            Text("페스코: 생선 허용, 육류는 금지")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.2902, green: 0.4353, blue: 0.3529))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Pesco"))
                )
            Text("폴로: 가금류(닭 등) 허용, 붉은 고기 금지")
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.7216, green: 0.3569, blue: 0.2941))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Pollo"))
                )
            Button {
                dismiss()
            } label: {
                Text("닫기")
                    .semibold16()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.top, 24)
            .padding(.horizontal, 16)
            .padding(.trailing, 10)
        }
        .padding(.leading, 10)
    }
}
