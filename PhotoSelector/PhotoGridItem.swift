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
    let isSelected: Bool
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
            
            // チェックマークオーバーレイ
            if isSelected {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Color.blue, in: Circle())
                            .font(.title2)
                            .padding(8)
                    }
                    Spacer()
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

#Preview {
    PhotoGridItem(
        asset: PHAsset(),
        isSelected: false,
        onTap: {}
    )
} 