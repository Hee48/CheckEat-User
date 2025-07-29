//
//  AddReivewView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/25/25.
//

import SwiftUI

enum RecommendType: String, CaseIterable, Identifiable {
    case nonVegan = "비건 아님"
    case vegan = "비건"
    case lacto = "락토"
    case ovo = "오보"
    case lactoOvo = "락토 오보"
    case pesco = "페스코"
    case pollo = "폴로"
    
    var id: String { rawValue }
}

enum MenuRecommendType: String, CaseIterable, Identifiable {
    case like = "추천 하고 싶어요"
    case neutral = "별 생각 없어요"
    case dislike = "추천 하고 싶지 않아요"
    
    var id: String { rawValue }
    
    var emoji: String {
        switch self {
        case .like: return "😋"
        case .neutral: return "🙂"
        case .dislike: return "😒"
        }
    }
}

struct AddReivewView: View {
    @State private var selectedMenu: String = ""
    @State private var selectedType: RecommendType = .nonVegan
    @State private var selectedRecommendation: MenuRecommendType = .like
    @State private var showMenuOptions = false
    @State private var dislikeReasonText = ""
    @State private var showVeganModal = false
    @State private var showReviewStopModal = false
    
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage? = nil
    @State private var showPickerSheet = false
    
    @State private var selectedImages: [UIImage] = []

    
    

    
    let menuOptions: [String] = ["연어초밥", "비건 김밥", "치킨버거", "토마토 파스타"]
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Text("리뷰 등록")
                        .medium16()
                    HStack {
                        Spacer()
                        Button {
                           showReviewStopModal = true
                        } label: {
                            Image("xmark")
                        }
                        .padding(.trailing, 20)
                    }
                }
                .frame(height: 44)
                
                Text("내가 먹은 음식에 대한 리뷰를 남겨\n많은 사람과 공유해보세요!")
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                
                AddReviewPhotoSection(
                    images: $selectedImages,
                    onAdd: {
                        showPickerSheet = true
                    },
                    onDelete: { index in
                        selectedImages.remove(at: index)
                    },
                )
                .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("내가 먹은 메뉴")
                        .semibold14()
                        .padding(.leading, 17)
                        .padding(.bottom, 2)
                    Button {
                       
                    } label: {
                        HStack {
                            Text("먹은 메뉴 고르기")
                                .regular14()
                                .foregroundColor(Color.gray.opacity(0.6))
                        }
                        .padding()
                        .frame(width: 362, height: 56)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1))
                    }
                    .padding(.horizontal, 17)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("어떤 사람에게 추천하시나요?")
                            .semibold14()
                    
                        Button {
                            showVeganModal = true
                        } label: {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 16))
                                .foregroundColor(.buttonOP20)
    
                        }
                    }
                    .padding(.top, 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 6) {
                            ForEach(RecommendType.allCases) { type in
                                Button {
                                    selectedType = type
                                } label: {
                                    Text(type.rawValue)
                                        .medium14()
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedType == type ? Color.black : Color.buttonOP20)
                                        .foregroundColor(selectedType == type ? .white : .black)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .frame(height: 40)
                    .padding(.top, 10)
                    Text("메뉴를 추천하시나요?")
                        .semibold14()
                        .padding(.top, 20)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 6) {
                            ForEach(MenuRecommendType.allCases) { type in
                                Button {
                                    selectedRecommendation = type
                                } label: {
                                    HStack {
                                        Text(type.emoji)
                                        Text(type.rawValue)
                                    }
                                    .medium14()
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedRecommendation == type ? Color.black : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedRecommendation == type ? .white : .black)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .frame(height: 40)
                    .padding(.top, 10)
                    if selectedRecommendation == .dislike {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("추천 하고 싶지 않은 이유를 알려주세요(필수)")
                                .semibold14()
                                .foregroundColor(.black)
                                .padding(.leading, 4)

                            TextField("간단히 작성", text: $dislikeReasonText)
                                .regular14()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
    
                        .padding(.top, 20)
                    }
                    if selectedRecommendation == .like {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("추천 하고 싶은 이유를 알려주세요(선택)")
                                .semibold14()
                                .foregroundColor(.black)
                                .padding(.leading, 4)

                            TextField("간단히 작성", text: $dislikeReasonText)
                                .regular14()
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
    
                        .padding(.top, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                Spacer()
                Button {
                    //서버에 리뷰 등록시키기
                } label: {
                    Text("리뷰 등록")
                        .primaryButtonStyle()
                        .semibold16()
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            if showMenuOptions {
                VStack(spacing: 0) {
                    ForEach(menuOptions, id: \.self) { option in
                        Button {
                            selectedMenu = option
                            withAnimation {
                                showMenuOptions = false
                            }
                        } label: {
                            HStack {
                                Text(option)
                                    .regular14()
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(radius: 4)
                )
                .padding(.horizontal, 17)
                .offset(y: 60)
                .zIndex(1)
            }
            
            if showReviewStopModal {
                ZStack {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(2)

                    ReviewStopModal {
                        showReviewStopModal = false
                    }
                    .frame(width: 362, height: 346)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .zIndex(3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .actionSheet(isPresented: $showPickerSheet) {
            ActionSheet(
                title: Text("사진 선택"),
                buttons: [
                    .default(Text("카메라")) {
                        imagePickerSource = .camera
                        showImagePicker = true
                    },
                    .default(Text("앨범")) {
                        imagePickerSource = .photoLibrary
                        showImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSource, selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                selectedImages.append(image)
            }
        }
        .sheet(isPresented: $showVeganModal) {
            VeganModal()
                .presentationDetents([.height(450)])
        }
    }
}
#Preview {
    AddReivewView()
}
