//
//  EmployeeService.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import Foundation

protocol EmployeeServiceProtocol {
    func fetchEmployees() async throws -> [Employee]
}

class EmployeeService: EmployeeServiceProtocol {
    private let urlString = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    private let malformedUrlString = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    private let emptyUrlString = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"
    
    private let cache: CacheManagerProtocol
    
    init(cache: CacheManagerProtocol = CacheManager.shared) {
        self.cache = cache
    }
    
    func fetchEmployees() async throws -> [Employee] {
        // Check cache first
        if let cachedEmployees = cache.getEmployees(), !cachedEmployees.isEmpty {
            return cachedEmployees
        }
        
        // Fetch from network
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(EmployeesResponse.self, from: data)
            cache.saveEmployees(response.employees)
            return response.employees
        } catch {
            throw NetworkError.decodingError
        }
    }
}
