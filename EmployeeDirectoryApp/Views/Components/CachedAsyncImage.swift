//
//  CachedAsyncImage.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI
import UIKit

struct CachedAsyncImage<Content: View>: View {
    let urlString: String
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> any View
    
    @State private var image: UIImage?
    
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
        
        if let cachedImage = ImageCache.shared.getImage(for: urlString) {
            self.image = cachedImage
            return
        }
        
   
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.saveImage(uiImage, for: urlString)
                await MainActor.run {
                    self.image = uiImage
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
