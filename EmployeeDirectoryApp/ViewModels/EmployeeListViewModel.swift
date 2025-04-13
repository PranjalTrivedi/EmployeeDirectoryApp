//
//  EmployeeListViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import Foundation
import SwiftUI

class EmployeeListViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    @Published var searchText = ""
    
    private let employeeService: EmployeeServiceProtocol
    
    init(employeeService: EmployeeServiceProtocol = EmployeeService()) {
        self.employeeService = employeeService
    }
    
    var filteredEmployees: [Employee] {
        if searchText.isEmpty {
            return employees
        } else {
            return employees.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func fetchEmployees() async {
        isLoading = true
        error = nil
        
        do {
            employees = try await employeeService.fetchEmployees()
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknown
        }
        
        isLoading = false
    }
    
    func refreshEmployees() {
        Task {
            await fetchEmployees()
        }
    }
}
