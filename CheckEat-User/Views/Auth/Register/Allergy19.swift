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
    @Environment(\.dismiss) private var dismiss
    init(allergy: String, onSubmit: @escaping (_ selectedAllergens: [Int], _ customText: String) -> Void) {
        _allergy = State(initialValue: allergy)
        self.onSubmit = onSubmit
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Text("allergy_my_info_title")
                        .semibold14()
                    
                    Text("allergy_input_hint_commas")
                        .foregroundColor(.buttonOP50)
                        .regular12()
                }
                .padding(.leading, 17)
                .padding(.top, 20)
                TextField("allergy_example_placeholder", text: $allergy)
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
                    customAllergyText: allergy.trimmingCharacters(in: .whitespacesAndNewlines),
                    onConfirm: { confirmedIDs, confirmedText in
                        onSubmit(confirmedIDs, confirmedText)
                    }
                )) {
                    Text("common_next")
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
                .navigationTitle("action_join")
                .navigationBarTitleDisplayMode(.inline)
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
}
//#Preview {
//    Allergy19(allergy: "") { _, _ in }
//}
