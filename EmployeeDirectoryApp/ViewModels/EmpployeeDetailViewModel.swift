//
//  EmpployeeDetailViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI
import UIKit

class EmployeeDetailViewModel: ObservableObject {
    @Published var image: UIImage?
    private let employee: Employee
    private let cache = ImageCache.shared
    
    init(employee: Employee) {
        self.employee = employee
    }
    
    func loadImage() {
        guard let urlString = employee.photoUrlLarge else { return }
        
        if let cachedImage = cache.getImage(for: urlString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self?.cache.saveImage(image, for: urlString)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
