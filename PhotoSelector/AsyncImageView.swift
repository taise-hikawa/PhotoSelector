//
//  AsyncImageView.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import Photos

struct AsyncImageView: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text("追加日時: \(asset.creationDate?.formatted() ?? "不明")")
                    .font(.caption)
                Text("サイズ: \(asset.pixelWidth) x \(asset.pixelHeight)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 80, height: 80),
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
    // プレビュー用のダミーアセット
    AsyncImageView(asset: PHAsset())
} 