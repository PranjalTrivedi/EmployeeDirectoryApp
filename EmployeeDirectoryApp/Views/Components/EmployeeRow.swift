//
//  EmployeeRow.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI
import UIKit

struct EmployeeRow: View {
    let employee: Employee
    @State private var image: UIImage?
    
    var body: some View {
        HStack(spacing: 12) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                    .onAppear { loadImage() }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.fullName)
                    .font(.headline)
                Text(employee.team)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func loadImage() {
        guard let urlString = employee.photoUrlSmall else { return }
        
      
        if let cachedImage = ImageCache.shared.getImage(for: urlString) {
            self.image = cachedImage
            return
        }
        
  
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                ImageCache.shared.saveImage(image, for: urlString)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
