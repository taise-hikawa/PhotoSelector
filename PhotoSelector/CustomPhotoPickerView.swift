//
//  CustomPhotoPickerView.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import Photos

struct CustomPhotoPickerView: View {
    @Binding var selectedImages: [PHAsset]
    @Environment(\.dismiss) private var dismiss
    @State private var allAssets: [PHAsset] = []
    @State private var hasPermission = false
    
    var body: some View {
        NavigationView {
            Group {
                if hasPermission {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 2) {
                        ForEach(allAssets, id: \.localIdentifier) { asset in
                            PhotoGridItem(
                                asset: asset,
                                isSelected: selectedImages.contains { $0.localIdentifier == asset.localIdentifier }
                            ) {
                                toggleSelection(asset: asset)
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                } else {
                    VStack {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("写真へのアクセス許可が必要です")
                            .font(.headline)
                        Button("設定を開く") {
                            openSettings()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("写真を選択")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            requestPhotoPermission()
        }
    }
    
    private func toggleSelection(asset: PHAsset) {
        if let index = selectedImages.firstIndex(where: { $0.localIdentifier == asset.localIdentifier }) {
            selectedImages.remove(at: index)
        } else {
            selectedImages.append(asset)
        }
    }
    
    private func requestPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            hasPermission = true
            loadPhotos()
        case .denied, .restricted:
            hasPermission = false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    self.hasPermission = status == .authorized || status == .limited
                    if self.hasPermission {
                        self.loadPhotos()
                    }
                }
            }
        @unknown default:
            hasPermission = false
        }
    }
    
    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        let results = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        
        results.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        
        DispatchQueue.main.async {
            self.allAssets = assets
        }
    }
    
    private func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

#Preview {
    CustomPhotoPickerView(selectedImages: .constant([]))
} 