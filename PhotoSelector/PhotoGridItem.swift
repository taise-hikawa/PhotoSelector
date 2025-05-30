//
//  PhotoGridItem.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import Photos

struct PhotoGridItem: View {
    let asset: PHAsset
    let selectionIndex: Int?
    let isAlreadyAdded: Bool
    let onTap: () -> Void
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3 - 2, height: UIScreen.main.bounds.width / 3 - 2)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 3 - 2, height: UIScreen.main.bounds.width / 3 - 2)
            }

            // 現在選択中のオーバーレイ
            if selectionIndex != nil {
                Rectangle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: UIScreen.main.bounds.width / 3 - 2, height: UIScreen.main.bounds.width / 3 - 2)
            }

            // マークを表示
            VStack {
                HStack {
                    // 追加済みマーク（左上）
                    if isAlreadyAdded {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.black)
                            .background(Color.white, in: Circle())
                            .font(.title3)
                            .padding(8)
                    }

                    Spacer()
                }

                Spacer()

                // 選択順番号（右下）
                if let selectionIndex = selectionIndex {
                    HStack {
                        Spacer()
                        Text("\(selectionIndex + 1)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.blue, in: Circle())
                            .padding(8)
                    }
                }
            }
        }
        .onTapGesture {
            onTap()
        }
        .onAppear {
            loadThumbnail()
        }
    }

    private func loadThumbnail() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isSynchronous = false

        let targetSize = CGSize(
            width: UIScreen.main.bounds.width / 3 * UIScreen.main.scale,
            height: UIScreen.main.bounds.width / 3 * UIScreen.main.scale
        )

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
