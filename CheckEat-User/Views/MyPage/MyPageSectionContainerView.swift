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
    case changeNickName
    case editAllergies
    case languageSettings

    var id: Self { self }
}

struct MyPageSectionContainerView: View {

    let handleSelection: (SettingDestination) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            SectionView(
                title: "section_store",
                buttons: [
                    (title: "section_favorite_stores", destination: .favoriteStores),
                    (title: "section_visited_stores", destination: .visitedStores)
                ]
            ) { destination in
                handleSelection(destination)
            }
            

            SectionView(
                title: "section_review",
                buttons: [(title: "section_written_reviews", destination: .reviewCreated)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "section_account",
                buttons: [(title: "action_change_password", destination: .changePassword),
                          (title: "action_change_nickname", destination: .changeNickName)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "section_allergy",
                buttons: [
                    (title: "action_edit_allergy", destination: .editAllergies)]
            ) { destination in
                handleSelection(destination)
            }

            SectionView(
                title: "section_language",
                buttons: [(title: "action_language_settings", destination: .languageSettings)]
            ) { destination in
                handleSelection(destination)
            }
        }
        .padding(.horizontal)
    }
}
