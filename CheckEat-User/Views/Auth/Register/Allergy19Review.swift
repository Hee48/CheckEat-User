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
    let allergenDataList: [Allergen] = AllergenData.defaultList
    var body: some View {
        NavigationStack {
            VStack {
                Text("allergy_info_check_title")
                    .bold20()
                    .padding(.top, 30)
                Text("allergy_info_check_desc")
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
                                            Text(item.displayName)
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
                        Text("allergy_my_info_title")
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
                Text("common_prev")
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
                Text("common_next")
                    .foregroundStyle(Color.white)
                    .semibold16()
                    .frame(minWidth: 130)
                    .padding()
                    .background(Color.buttonEnable)
                    .cornerRadius(5)
                
                }
            }
            .padding(.trailing, 25)
            .navigationTitle("action_join")
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
