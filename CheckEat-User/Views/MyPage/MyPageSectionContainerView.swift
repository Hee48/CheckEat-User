//
//  MyPageSectionContainerView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/16/25.
//

import SwiftUI

enum SettingDestination: Hashable, Identifiable {
    case visitedStores
    case favoriteStores
    case reviewCreated
    case changePassword
    case editAllergies
    case languageSettings

    var id: Self { self }
}

struct MyPageSectionContainerView: View {

    let handleSelection: (SettingDestination) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            SectionView(
                title: "가게",
                buttons: [
                    (title: "즐겨찾기 가게", destination: .favoriteStores),
                    (title: "이용한 가게", destination: .visitedStores)
                ]
            ) { destination in
                handleSelection(destination)
            }
            

            SectionView(
                title: "리뷰",
                buttons: [(title: "작성한 리뷰", destination: .reviewCreated)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "계정",
                buttons: [(title: "비밀번호 변경", destination: .changePassword)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "알러지",
                buttons: [
                    (title: "알러지 수정", destination: .editAllergies)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "언어",
                buttons: [(title: "언어설정", destination: .languageSettings)]
            ) { destination in
                handleSelection(destination)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    MyPageSectionContainerView { _ in }
//}
