//
//  MenuChoicePage.swift
//  CheckEat-User
//
//  Created by Hee  on 7/30/25.
//

import SwiftUI

struct MenuChoicePage: View {
    @State private var searchText: String = ""
    @State private var checkedItems: [Int: Bool] = [:]
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedMenu: [(id: Int, name: String)]
    @EnvironmentObject var viewModel: ReviewViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
            ZStack {
                Text("리뷰 등록")
                    .medium16()
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 44)
            }
            VStack(alignment: .leading) {
                Text("내가 먹은 메뉴")
                    .bold20()
                    .padding(.top, 20)
                SearchBar(searchText: $searchText, placeholder: "내가 먹은 메뉴이름을 검색해보세요.") {
                    print("검색어: \(searchText)")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                .padding(.top, 10)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.menuList.filter {
                        searchText.isEmpty ? true : $0.foo_name.localizedCaseInsensitiveContains(searchText)
                    }, id: \.foo_id) { menu in
                        HStack(spacing: 16) {
                            CheckBoxButton(isChecked: Binding(
                                get: { checkedItems[menu.foo_id] ?? false },
                                set: { checkedItems[menu.foo_id] = $0 }
                            ))
                            AsyncImage(url: URL(string: menu.foo_img ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .clipped()
                            .padding(.top, 10)
                            VStack(alignment: .leading) {
                                Text(menu.foo_name)
                                    .semibold18()
                                Text("\(menu.foo_price.formatted())원")
                                    .bold14()
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    }
                }
            }
            
            Button {
                selectedMenu = viewModel.menuList
                    .filter { checkedItems[$0.foo_id] == true }
                    .map { ($0.foo_id, $0.foo_name) }
                dismiss()
            } label: {
                Text("선택 완료")
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(width: 362, height: 56)
                    .padding(.leading, 20)
            }
        }
        .frame(height: geometry.size.height)
    }
    }
}
