//
//  MenuChoicePage.swift
//  CheckEat-User
//
//  Created by Hee  on 7/30/25.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let menuName: String
    let price: Int
}

let dummyMenus: [MenuItem] = [
    MenuItem(menuName: "연어초밥", price: 6000),
    MenuItem(menuName: "아보카도롤", price: 5500),
    MenuItem(menuName: "비건김밥", price: 5000),
    MenuItem(menuName: "유부초밥", price: 4500),
    MenuItem(menuName: "채소비빔밥", price: 7000),
    MenuItem(menuName: "두부덮밥", price: 6500),
    MenuItem(menuName: "토마토파스타", price: 8000)
]

struct MenuChoicePage: View {
    @State private var searchText: String = ""
    @State private var checkedItems: [UUID: Bool] = [:]
    @Environment(\.dismiss) private var dismiss
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
                    ForEach(dummyMenus.filter {
                        searchText.isEmpty ? true : $0.menuName.localizedCaseInsensitiveContains(searchText)
                    }) { menu in
                        HStack(spacing: 16) {
                            CheckBoxButton(isChecked: Binding(
                                get: { checkedItems[menu.id] ?? false },
                                set: { checkedItems[menu.id] = $0 }
                            ))
                            Image("testImage")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .padding(.top, 10)
                            VStack(alignment: .leading) {
                                Text(menu.menuName)
                                    .semibold18()
                                Text("\(menu.price.formatted())원")
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
                //AddReviewView페이지로 선택한 메뉴 데이터 전달해야함
            } label: {
                Text("선택 완료")
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(width: 362, height: 56)
            }
            .padding(.leading, 20)
        }
        .frame(height: geometry.size.height)
    }
    }
}
#Preview {
    MenuChoicePage()
}
