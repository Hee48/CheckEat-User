//
//  CameraCaptureView.swift
//  CheckEat-User
//
//  Created by Hee  on 8/4/25.
//

import Foundation
import SwiftUI
import Photos

struct CameraCaptureView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    var onDismiss: () -> Void = {}
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        if sourceType == .photoLibrary {
            PHPhotoLibrary.requestAuthorization { status in
                print("앨범 권한 상태: \(status)")
            }
        }

        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.modalPresentationStyle = .fullScreen
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraCaptureView
        
        init(_ parent: CameraCaptureView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            picker.dismiss(animated: true, completion: parent.onDismiss)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: parent.onDismiss)
        }
    }
}
 
