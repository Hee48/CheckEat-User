//
//  Allergy19.swift
//  CheckEat-User
//
//  Created by Hee  on 7/25/25.
//

import SwiftUI

struct Allergy19: View {
    var onSubmit: (_ selectedAllergens: [Int], _ customText: String) -> Void
    @State private var allergy: String
    @State private var selectedAllergens: Set<Int> = []
    init(allergy: String, onSubmit: @escaping (_ selectedAllergens: [Int], _ customText: String) -> Void) {
        _allergy = State(initialValue: allergy)
        self.onSubmit = onSubmit
    }
    var body: some View {
        NavigationStack {
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
                TextField("아래에 해당하지 않는 알레르기 재료를 적어주세요.", text: $allergy)
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
                        ForEach(AllergenData.defaultList, id: \.id) { item in
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
                                                    selectedAllergens.insert(item.id)
                                                } else {
                                                    selectedAllergens.remove(item.id)
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
                
                NavigationLink(destination:  Allergy19Review(
                    selectedAllergyIDs: Array(selectedAllergens),
                    customAllergyText: allergy,
                    onConfirm: { confirmedIDs, confirmedText in
                        onSubmit(confirmedIDs, confirmedText)
                    }
                )) {
                    Text("다음")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("Button_Enable"))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                Spacer()
                .navigationTitle("회원가입")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            //                    dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.black)
                        }
                    }
                }
                
            }
            
        }

    }
}
#Preview {
    Allergy19(allergy: "") { _, _ in }
}
