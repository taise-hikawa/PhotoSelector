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
    let isCurrentlySelected: Bool
    let isAlreadyAdded: Bool
    let onTap: () -> Void
    @State private var image: UIImage?
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
            }
            
            // 現在選択中のオーバーレイ
            if isCurrentlySelected {
                Rectangle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
            }
            
            // マークを表示
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        // 現在選択中のチェックマーク
                        if isCurrentlySelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                                .background(Color.blue, in: Circle())
                                .font(.title2)
                        }
                        
                        // 追加済みマーク
                        if isAlreadyAdded {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                                .background(Color.green, in: Circle())
                                .font(.title3)
                        }
                    }
                    .padding(8)
                }
                Spacer()
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

#Preview {
    PhotoGridItem(
        asset: PHAsset(),
        isCurrentlySelected: false,
        isAlreadyAdded: true,
        onTap: {}
    )
} 