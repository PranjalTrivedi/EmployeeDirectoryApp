//
//  EmpployeeDetailViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import Foundation
import SwiftUI

class EmployeeDetailViewModel: ObservableObject {
    @Published var isLoadingImage = false
    @Published var image: UIImage?
    @Published var error: NetworkError?
    
    private let employee: Employee
    private let cache: CacheManagerProtocol
    
    init(employee: Employee, cache: CacheManagerProtocol = CacheManager.shared) {
        self.employee = employee
        self.cache = cache
    }
    
    var name: String { employee.fullName }
    var phone: String? { employee.phoneNumber }
    var email: String { employee.emailAddress }
    var biography: String? { employee.biography }
    var team: String { employee.team }
    var employeeType: String { employee.employeeType.displayName }
    
    func loadImage() {
        guard let photoUrl = employee.photoUrlLarge else {
            return
        }
        
        // Check cache first
        if let cachedImage = cache.getImage(for: photoUrl) {
            self.image = cachedImage
            return
        }
        
        isLoadingImage = true
        error = nil
        
        Task {
            do {
                guard let url = URL(string: photoUrl) else {
                    throw NetworkError.invalidURL
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.image = uiImage
                        self.cache.saveImage(uiImage, for: photoUrl)
                        self.isLoadingImage = false
                    }
                } else {
                    throw NetworkError.invalidData
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    self.error = error
                    self.isLoadingImage = false
                }
            } catch {
                await MainActor.run {
                    self.error = .unknown
                    self.isLoadingImage = false
                }
            }
        }
    }
}
