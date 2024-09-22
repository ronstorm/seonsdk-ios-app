//
//  ContentView.swift
//  SampleSeonApp
//
//  Created by Amit on 16.09.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sdkManager = PhotoSDKManager()
    @State private var showCameraView = false
    @State private var showGalleryView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Button to take a photo
                Button(action: {
                    showCameraView = true
                }) {
                    Text("Take a Photo")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showCameraView, content: {
                    sdkManager.takePhoto {
                        showCameraView = false  // Close the camera after capturing the photo
                    }
                })
                
                // Show the captured image if available
                if let capturedImage = sdkManager.capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                // Button to view photos (requires biometric authentication)
                Button(action: {
                    sdkManager.accessPhotos {
                        showGalleryView = true  // Open gallery after successful authentication
                    }
                }) {
                    Text("View Photos")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showGalleryView, content: {
                    if let galleryView = sdkManager.galleryView {
                        galleryView
                    }
                })
            }
            .padding()
            .navigationTitle("SEON")
            .alert(isPresented: $sdkManager.showError) {
                Alert(title: Text("Error"), message: Text(sdkManager.errorMessage ?? "Unknown Error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}



//#Preview {
//    ContentView()
//}
