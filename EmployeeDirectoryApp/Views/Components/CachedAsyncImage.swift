//
//  CachedAsyncImage.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    private let urlString: String
    private let content: (Image) -> Content
    private let placeholder: () -> any View
    
    @State private var image: UIImage?
    
    init(
        urlString: String,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> any View
    ) {
        self.urlString = urlString
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                AnyView(placeholder())
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        if let cachedImage = CacheManager.shared.getImage(for: urlString) {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                CacheManager.shared.saveImage(uiImage, for: urlString)
                image = uiImage
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
