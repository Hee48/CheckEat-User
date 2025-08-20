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
            Text("vegan_modal_title".localized)
                .bold20()
                .padding(.top, 10)
            Text("vegan_modal_subtitle".localized)
                .padding(.top, 10)
            Text("vegan_type_vegan".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.1686, green: 0.4784, blue: 0.4196))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Vegan"))
                )
                .padding(.top, 10)
            Text("vegan_type_lacto".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.4784, green: 0.451, blue: 0.1725))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Lacto"))
                )
            Text("vegan_type_ovo".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.3725, green: 0.2941, blue: 0.5451))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Ovo"))
                )
            Text("vegan_type_lactoovo".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.2039, green: 0.4941, blue: 0.5804))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Lacto-ovo"))
                )
            Text("vegan_type_pesco".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.2902, green: 0.4353, blue: 0.3529))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Pesco"))
                )
            Text("vegan_type_pollo".localized)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .foregroundColor(Color(red: 0.7216, green: 0.3569, blue: 0.2941))
                .background(RoundedRectangle(cornerRadius: 30)
                    .fill(Color("Pollo"))
                )
            Button {
                dismiss()
            } label: {
                Text("common_close".localized)
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
