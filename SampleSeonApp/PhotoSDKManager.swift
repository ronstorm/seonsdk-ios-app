//
//  PhotoSDKManager.swift
//  SampleSeonApp
//
//  Created by Amit on 16.09.24.
//

import SwiftUI
import UIKit.UIImage
import SeonSDK

class PhotoSDKManager: ObservableObject {
    private let photoSDK = PhotoSDK()

    @Published var capturedImage: UIImage?
    @Published var galleryView: AnyView?
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // Method to handle taking a photo
    func takePhoto(completion: @escaping () -> Void) -> some View {
        return photoSDK.takePhoto { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.capturedImage = image
                    completion()  // Notify the caller that the operation is complete
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    // Method to handle authentication and access the photo gallery
    func accessPhotos(completion: @escaping () -> Void) {
        photoSDK.accessPhotos { result in
            switch result {
            case .success(let gallery):
                DispatchQueue.main.async {
                    self.galleryView = gallery
                    completion()  // Notify the caller that the operation is complete
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
