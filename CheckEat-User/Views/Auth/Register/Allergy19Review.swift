//
//  Allergy19Review.swift
//  CheckEat-User
//
//  Created by Hee  on 7/25/25.
//

import SwiftUI

struct Allergy19Review: View {
    let selectedAllergyIDs: [Int]
    let customAllergyText: String
    var onConfirm: (_ ids: [Int], _ text: String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showJoinComplete = false
    // Shared allergen data list
    let allergenDataList: [(id: Int, name: String, imageName: String)] = [
        (1, "난류", "난류"),
        (2, "우유", "우유"),
        (3, "메밀", "메밀"),
        (4, "땅콩", "땅콩"),
        (5, "대두", "대두"),
        (6, "밀", "밀"),
        (7, "고등어", "고등어"),
        (8, "게", "게"),
        (9, "새우", "새우"),
        (10, "돼지고기", "돼지고기"),
        (11, "복숭아", "복숭아"),
        (12, "토마토", "토마토"),
        (13, "아황산류", "아황산류"),
        (14, "호두", "호두"),
        (15, "닭고기", "닭고기"),
        (16, "쇠고기", "쇠고기"),
        (17, "오징어", "오징어"),
        (18, "조개류", "조개류"),
        (19, "잣", "잣")
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Text("알레르기 정보 확인")
                    .bold20()
                    .padding(.top, 30)
                Text("입력한 정보에 수정사항이 있는지 확인해 주세요.")
                    .regular16()
                    .padding(.top, 20)
            }
            ScrollView {
                    if !selectedAllergyIDs.isEmpty {
                        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16) {
                            ForEach(selectedAllergyIDs, id: \.self) { id in
                                if let item = allergenDataList.first(where: { $0.id == id }) {
                                    ZStack(alignment: .topTrailing) {
                                        ZStack(alignment: .center) {
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 112, height: 118)
                                            Text(item.name)
                                                .bold20()
                                                .foregroundColor(.black)
                                                .frame(width: 112, alignment: .center)
                                                .padding(.top, 75)
                                        }
                                        .frame(width: 112, height: 118)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        
                                        Image(systemName: "checkmark.square.fill")
                                            .foregroundStyle(Color("Button_Enable"))
                                            .padding(6)
                                            .font(.system(size: 22, weight: .semibold))
                                    }
                                    .padding(.top, 20)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    Spacer()
                }


                VStack(alignment: .leading) {
                    if !customAllergyText.trimmingCharacters(in: .whitespaces).isEmpty {
                        Text("나의 알러지 정보")
                            .semibold14()
                            .padding(.top, 20)
                        Text(customAllergyText)
                            .regular14()
                            .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            HStack {
            Button {
                dismiss()
            } label: {
                Text("이전")
                    .foregroundStyle(Color.buttonEnable)
                    .semibold16()
                    .frame(minWidth: 130)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.3)
                    )
            }
            .padding()
            Button {
                onConfirm(selectedAllergyIDs, customAllergyText)
            } label: {
                Text("다음")
                    .foregroundStyle(Color.white)
                    .semibold16()
                    .frame(minWidth: 130)
                    .padding()
                    .background(Color.buttonEnable)
                    .cornerRadius(5)
                
                }
            }
            .padding(.trailing, 25)
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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

//#Preview {
//    Allergy19Review(selectedAllergyIDs: [2, 4, 7], customAllergyText: "납작복숭아,송충이털"), onConfirm: {})
//}
