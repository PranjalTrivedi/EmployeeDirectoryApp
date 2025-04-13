//
//  EmployeeService.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import Foundation

class EmployeeService {
    private let urlString = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    private let cache = ImageCache.shared // Changed from CacheManager to ImageCache
    
    func fetchEmployees() async throws -> [Employee] {
        if let cachedEmployees = cache.getEmployees(), !cachedEmployees.isEmpty {
            return cachedEmployees
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let response = try JSONDecoder().decode(EmployeesResponse.self, from: data)
            cache.saveEmployees(response.employees)
            return response.employees
        } catch {
            throw NetworkError.decodingError
        }
    }
}
