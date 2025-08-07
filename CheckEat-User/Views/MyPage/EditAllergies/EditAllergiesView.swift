//
//  EditAllergiesView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct EditAllergiesView: View {
    let selectedAllergyIDs: [Int]
    let customAllergyText: String
    var onConfirm: (_ ids: [Int], _ text: String) -> Void
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @State private var showEditAllergies19 = false
    @State private var shouldDismiss = false
    @Binding var isPresented: Bool
    let allergenDataList: [(id: Int, name: String, imageName: String)] = [
        (1, "난류", "Egg"),
        (2, "우유", "Milk"),
        (3, "메밀", "Buckwheat"),
        (4, "땅콩", "Peanut"),
        (5, "대두", "Soy"),
        (6, "밀", "Wheat"),
        (7, "고등어", "Mackerel"),
        (8, "게", "Crab"),
        (9, "새우", "Shrimp"),
        (10, "돼지고기", "Pork"),
        (11, "복숭아", "Peach"),
        (12, "토마토", "Tomato"),
        (13, "아황산류", "Sulfites"),
        (14, "호두", "Walnut"),
        (15, "닭고기", "Chicken"),
        (16, "쇠고기", "Beef"),
        (17, "오징어", "Squid"),
        (18, "조개류", "Shellfish"),
        (19, "잣", "PineNut")
    ]
    
    var body: some View {
            VStack {
                Text("알레르기 정보 확인")
                    .bold20()
                    .padding(.top, 30)
                Text("나의 알레르기 정보를 확인해주세요.")
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
            Button {
                showEditAllergies19 = true
            } label: {
                Text("수정")
                    .foregroundStyle(Color.white)
                    .semibold16()
                    .primaryButtonStyle(isEnabled: true)
                    .background(Color.buttonEnable)
                    .cornerRadius(5)
                    .padding(.leading, 20)
                    .padding(.trailing, 25)
                
            }
            NavigationLink(
                destination: EditAllergies19(
                    allergy: "",
                    onSubmit: { selectedAllergens, customText in
                        onConfirm(selectedAllergens, customText)
                        shouldDismiss = false
                        isPresented = false
                    },
                    path: $path
                ),
                isActive: $showEditAllergies19
            ) {
                EmptyView()
            }
            .hidden()
            .onChange(of: shouldDismiss) { newValue in
                if newValue {
                    dismiss()
                }
            }
            .navigationTitle("알레르기 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

//#Preview {
//    EditAllergiesView(selectedAllergyIDs: [2, 4, 7], customAllergyText: "납작복숭아,송충이털", onConfirm: {ids,text in })
//}
