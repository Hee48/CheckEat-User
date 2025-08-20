//
//  FindIDComplete.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import SwiftUI

struct FindIDComplete: View {
    let userID: String
    @Binding var showFindId: Bool
    @Binding var showFindPw: Bool
    @Binding var findPath: [FindIDPath]
    
    var body: some View {
        
        VStack(spacing: 8) {
            Image("CheckMark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom, 16)
            Text("find_id_message_prefix")
                .foregroundColor(.buttonOP70)
                .medium16()
            Text(userID)
                .font(.system(size: 16, weight: .semibold))
            + Text("find_id_message_suffix")
                .foregroundColor(.buttonOP70)
                .font(.system(size: 16, weight: .medium))
                
            HStack {
                Text("find_pw_question")
                    .foregroundStyle(.buttonOP70)
                    .regular14()
                Button {
                    showFindId = false
                    DispatchQueue.main.async {
                        findPath.removeAll()
                        showFindPw = true
                    }
                } label: {
                    Text("find_pw_button")
                        .bold14()
                        .foregroundStyle(.buttonAuth)
                }
            }
            .padding(.vertical)
            
            Button {
                showFindId = false
            } label: {
                Text("Login")
                    .primaryButtonStyle()
                    .semibold16()
            }
            .padding(.vertical, 8)
        }
        .padding()
        .padding(.bottom, 200)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
}
