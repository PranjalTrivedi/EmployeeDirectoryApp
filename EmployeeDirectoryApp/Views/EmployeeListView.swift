//
//  EmployeeListView.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI

struct EmployeeListView: View {
    @StateObject private var viewModel = EmployeeListViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.employees.isEmpty {
                    LoadingView()
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task {
                            await viewModel.fetchEmployees()
                        }
                    })
                } else if viewModel.filteredEmployees.isEmpty {
                    EmptyStateView()
                } else {
                    List(viewModel.filteredEmployees) { employee in
                        NavigationLink(destination: EmployeeDetailView(employee: employee)) {
                            EmployeeRow(employee: employee)
                        }
                    }
                }
            }
            .navigationTitle("Employees")
            .searchable(text: $viewModel.searchText)
            .refreshable {
                viewModel.refreshEmployees()
            }
        }
        .navigationViewStyle(.stack) // Force stack navigation style
        .task {
            await viewModel.fetchEmployees()
        }
    }
}
