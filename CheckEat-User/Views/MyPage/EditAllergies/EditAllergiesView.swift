//
//  EditAllergiesView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct EditAllergiesView: View {
    @State private var allergyIDs: [Int] = []
    @State private var customAllergy: String = ""
    var onConfirm: (_ ids: [Int], _ text: String) -> Void
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @State private var showEditAllergies19 = false
    @State private var shouldDismiss = false
    @Binding var isPresented: Bool
    @StateObject private var myPageViewModel = MyPageViewModel()
    let allergenDataList: [Allergen] = AllergenData.defaultList
    var body: some View {
            VStack {
                Text("allergy_info_check_title")
                    .bold20()
                    .padding(.top, 30)
                Text("allergy_info_check_subtitle")
                    .regular16()
                    .padding(.top, 20)
            }
            .onAppear {
                if let allergy = myPageViewModel.loadAllergiesFromToken() {
                    let ids = allergy.commonAllergies.map { $0.coal_id }
                    print("📦 토큰에서 받아온 allergyIDs: \(ids)")
                    
                    for id in ids {
                        if let matched = allergenDataList.first(where: { $0.id == id }) {
                            print("✅ 매칭됨: \(matched.nameKey)")
                            let resolved = matched.displayName
                            print("🔤 resolved localized: \(resolved)")
                        } else {
                            print("❌ 매칭 실패: \(id)")
                        }
                    }

                    allergyIDs = ids
                    customAllergy = allergy.directAllergy
                }
            }
            ScrollView {
                if !allergyIDs.isEmpty {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16) {
                        ForEach(allergyIDs, id: \.self) { id in
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
                    if !customAllergy.trimmingCharacters(in: .whitespaces).isEmpty {
                        Text("allergy_my_info_title")
                            .semibold14()
                            .padding(.top, 20)
                        Text(customAllergy)
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
                Text("action_edit")
                    .foregroundStyle(Color.white)
                    .semibold16()
                    .primaryButtonStyle(isEnabled: true)
                    .background(Color.buttonEnable)
                    .cornerRadius(5)
                    .padding(.leading, 20)
                    .padding(.trailing, 25)
                    .padding(.bottom, 30)
                
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
            .navigationTitle("allergy_edit_title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
