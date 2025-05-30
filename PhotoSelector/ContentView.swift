//
//  ContentView.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import PhotosUI
import Photos

struct ContentView: View {
    @State private var selectedImages: [PHAsset] = []
    @State private var showingPhotoPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 選択された画像のリスト
                List {
                    ForEach(selectedImages, id: \.localIdentifier) { asset in
                        AsyncImageView(asset: asset)
                            .frame(height: 100)
                    }
                    .onDelete(perform: deleteImages)
                }
                
                Spacer()
                
                // 写真選択ボタン
                Button("写真を選択") {
                    showingPhotoPicker = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Photo Selector")
            .sheet(isPresented: $showingPhotoPicker) {
                CustomPhotoPickerView(selectedImages: $selectedImages)
            }
        }
    }
    
    private func deleteImages(offsets: IndexSet) {
        selectedImages.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
