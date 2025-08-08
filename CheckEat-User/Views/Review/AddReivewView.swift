//
//  AddReivewView.swift
//  CheckEat-User
//
//  Created by Hee  on 7/25/25.
//

import SwiftUI

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
    var serverValue: Int {
        switch self {
        case .like: return 0
        case .neutral: return 1
        case .dislike: return 2
        }
    }
}

struct AddReivewView: View {
    @State private var selectedType: VeganLevel = .none
    @State private var selectedRecommendation: MenuRecommendType = .like
    @State private var dislikeReasonText = ""
    @State private var likeReasonText = ""
    @State private var showReviewStopModal = false
    
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage? = nil
    @State private var showPickerSheet = false
    @State private var showMenuChoice = false
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedMenu: [(id: Int, name: String)] = []
    @StateObject private var viewModel = ReviewViewModel()
    @Binding var isPresented: Bool
    @Binding var showCheckModal: Bool
    @Binding var reviewPath: [ReviewPath]
    @Binding var isReviewFlowActive: Bool

    let storeId: Int
    
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
                        guard selectedImages.count < 4 else { return }
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
                        viewModel.registPageStroeMenu(storeId: storeId)
                        showMenuChoice = true
                    } label: {
                        selectedMenuTextView(selectedMenu: selectedMenu)
                    }
                    .padding(.horizontal, 17)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    VeganTypeSelectorView(selectedType: $selectedType)
                        .frame(height: 40)
                        .padding(.top, 20)
                    RecommendationSectionView(
                        selectedRecommendation: $selectedRecommendation,
                        likeReasonText: $likeReasonText,
                        dislikeReasonText: $dislikeReasonText
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 5)
                Spacer()
                registerButton
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
            ImagePicker(
                sourceType: imagePickerSource,
                selectedImage: $selectedImage,
                selectedImages: $selectedImages
            )
            .onDisappear {
                if selectedImages.count > 4 {
                    selectedImages = Array(selectedImages.prefix(4))
                }
            }
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage, selectedImages.count < 4 {
                selectedImages.append(image)
            }
        }
        .fullScreenCover(isPresented: $showMenuChoice) {
            MenuChoicePage(selectedMenu: $selectedMenu)
                .environmentObject(viewModel)
        }
        .onReceive(viewModel.$registerSuccess) { success in
            if success {
                isPresented = false
                showCheckModal = false
                reviewPath.removeAll()
                isReviewFlowActive = false
                
            }
        }
    }
    
    private var registerButton: some View {
        RegisterButtonView(
            selectedType: selectedType,
            selectedRecommendation: selectedRecommendation,
            dislikeReasonText: dislikeReasonText,
            likeReasonText: likeReasonText,
            selectedMenu: selectedMenu,
            storeId: storeId,
            viewModel: viewModel,
            selectedImages: selectedImages
        )
    }
}
private func selectedMenuTextView(selectedMenu: [(id: Int, name: String)]) -> some View {
    let text: String
    if selectedMenu.isEmpty {
        text = "메뉴 선택하기"
    } else {
        text = selectedMenu.map { $0.name }.joined(separator: ", ")
    }
    return Text(text)
        .regular14()
        .foregroundColor(.black)
        .padding()
        .frame(width: 362, height: 56)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
}

private struct RegisterButtonView: View {
    let selectedType: VeganLevel
    let selectedRecommendation: MenuRecommendType
    let dislikeReasonText: String
    let likeReasonText: String
    let selectedMenu: [(id: Int, name: String)]
    let storeId: Int
    let viewModel: ReviewViewModel
    let selectedImages: [UIImage]
    
    var body: some View {
        Button {
            let veganLevel = selectedType.rawValue
            let recommendation = selectedRecommendation.serverValue
            let dislikeReason = dislikeReasonText.trimmingCharacters(in: .whitespacesAndNewlines)
            let likeReason = likeReasonText.trimmingCharacters(in: .whitespacesAndNewlines)
            let reviewContent = selectedRecommendation == .dislike ? dislikeReason : likeReason
            let foodIDs = selectedMenu.map { $0.id }
            
            
            // ✅ 디버깅용 프린트
            print("👉 보내는 데이터:")
            print("foodIDs: \(foodIDs)")
            print("storeID: \(storeId)")
            print("reviewContent: \(reviewContent)")
            print("veganLevel: \(veganLevel)")
            print("recommendStep: \(recommendation)")
            print("status: 0")
            print("images count:", selectedImages.count)
            
            viewModel.registerReview(
                foodIDs: foodIDs,
                storeID: storeId,
                reviewContent: reviewContent,
                veganLevel: veganLevel,
                recommendStep: recommendation,
                status: 0,
                images: selectedImages
            )
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
}
