//
//  EditAllergies19.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct EditAllergies19: View {
    @Environment(\.presentationMode) private var presentationMode
    var onSubmit: (_ selectedAllergens: [Int], _ customText: String) -> Void
    @State private var allergy: String
    @State private var selectedAllergens: [Int] = []
    @StateObject var viewModel = EditAllergiesViewModel()
    @Binding var path: NavigationPath
    init(
        allergy: String,
        onSubmit: @escaping (_ selectedAllergens: [Int], _ customText: String) -> Void,
        path: Binding<NavigationPath>
    ) {
        _allergy = State(initialValue: allergy)
        self.onSubmit = onSubmit
        self._path = path
    }
    var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text("나의 알러지 정보")
                        .semibold14()
                    
                    Text("쉼표(,)로 구분해서 작성해주세요.")
                        .foregroundColor(.buttonOP50)
                        .regular12()
                }
                .padding(.leading, 17)
                .padding(.top, 20)
                TextField("ex. 키위,바나나,고사리,참깨,감귤류", text: $allergy)
                    .regular14()
                    .padding(.horizontal, 10)
                    .frame(width: 362, height: 52)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.leading, 17)
                
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 3), spacing: 16) {
                        ForEach(AllergenData.defaultList) { item in
                            ZStack(alignment: .topTrailing) {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 112, height: 118)
                                    .cornerRadius(8)

                                Text(item.displayName)
                                     .bold20()
                                     .foregroundColor(.black)
                                     .frame(width: 112, alignment: .center)
                                     .padding(.top, 75)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    CheckBoxButton(
                                        isChecked: Binding(
                                            get: { selectedAllergens.contains(item.id)},
                                            set: { newValue in
                                                if newValue {
                                                    if !selectedAllergens.contains(item.id) {
                                                        selectedAllergens.append(item.id)
                                                        selectedAllergens.sort()
                                                    }
                                                } else {
                                                    selectedAllergens.removeAll(where: { $0 == item.id })
                                                }
                                            }
                                        )
                                    )
                                    .padding(8)

                                   
                                    
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Button {
                    onSubmit(selectedAllergens, allergy.trimmingCharacters(in: .whitespacesAndNewlines))
                    viewModel.editAllergies(commonIDs: selectedAllergens, personalAllergy: allergy)
                } label: {
                    Text("완료")
                        .semibold16()
                        .primaryButtonStyle(isEnabled: true)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .padding(.top, 20)
                .onChange(of: viewModel.isSuccess) { isSuccess in
                    if isSuccess {
                        path = NavigationPath()
                    }
                }
                
                Spacer()

                .navigationTitle("알레르기 수정")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            
        }

}
