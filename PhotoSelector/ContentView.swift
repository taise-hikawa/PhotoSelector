//
//  ContentView.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import SwiftData
import Photos

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedPhoto.order) private var savedPhotos: [SavedPhoto]
    @State private var selectedImages: [PHAsset] = []
    @State private var showingPhotoPicker = false

    var body: some View {
        NavigationStack {
            VStack {
                // 選択された画像のリスト
                if selectedImages.isEmpty {
                    ContentUnavailableView(
                        "画像が追加されていません",
                        systemImage: "photo.on.rectangle",
                        description: Text("下のボタンから写真を選択して追加しましょう")
                    )
                } else {
                    List {
                        ForEach(Array(selectedImages.enumerated()), id: \.element.localIdentifier) { index, asset in
                            AsyncImageView(asset: asset)
                                .frame(height: 100)
                        }
                        .onDelete(perform: deleteImages)
                        .onMove(perform: moveImages)
                    }
                }
                // 写真選択ボタン
                Button("写真を選択") {
                    showingPhotoPicker = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Photo Selector")
            .toolbar {
                if !selectedImages.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingPhotoPicker) {
                CustomPhotoPickerView(
                    addedImages: selectedImages,
                    onImagesSelected: { newImages in
                        addImages(newImages)
                    }
                )
            }
        }
        .onAppear {
            loadSavedImages()
        }
        .onChange(of: savedPhotos) { _, _ in
            loadSavedImages()
        }
    }

    private func addImages(_ newImages: [PHAsset]) {
        let currentMaxOrder = savedPhotos.map(\.order).max() ?? -1

        for (index, asset) in newImages.enumerated() {
            // 重複チェックを削除して、同じ画像でも追加可能にする
            let savedPhoto = SavedPhoto(
                identifier: asset.localIdentifier,
                addedDate: Date(),
                order: currentMaxOrder + index + 1
            )
            modelContext.insert(savedPhoto)
        }

        try? modelContext.save()
    }

    private func deleteImages(offsets: IndexSet) {
        let assetsToDelete = offsets.map { selectedImages[$0] }

        for asset in assetsToDelete {
            if let savedPhoto = savedPhotos.first(where: { $0.identifier == asset.localIdentifier }) {
                modelContext.delete(savedPhoto)
            }
        }

        try? modelContext.save()
    }

    private func moveImages(from source: IndexSet, to destination: Int) {
        var newSelectedImages = selectedImages
        newSelectedImages.move(fromOffsets: source, toOffset: destination)

        // 新しい順序でorderを更新
        for (index, asset) in newSelectedImages.enumerated() {
            if let savedPhoto = savedPhotos.first(where: { $0.identifier == asset.localIdentifier }) {
                savedPhoto.order = index
            }
        }

        try? modelContext.save()
    }

    private func loadSavedImages() {
        let identifiers = savedPhotos.map { $0.identifier }

        guard !identifiers.isEmpty else {
            selectedImages = []
            return
        }

        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: fetchOptions)

        var loadedAssets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            loadedAssets.append(asset)
        }

        // 保存された順序を維持
        selectedImages = savedPhotos.compactMap { savedPhoto in
            loadedAssets.first { $0.localIdentifier == savedPhoto.identifier }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SavedPhoto.self, inMemory: true)
}
