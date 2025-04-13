//
//  EmployeeDetailView.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI

struct EmployeeDetailView: View {
    @ObservedObject var viewModel: EmployeeDetailViewModel
    let employee: Employee
    
    init(employee: Employee) {
        self.employee = employee
        self.viewModel = EmployeeDetailViewModel(employee: employee)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Photo Section
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    ProgressView()
                        .frame(width: 200, height: 200)
                }
                
         
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Name", value: employee.fullName)
                    
                    if let phone = employee.phoneNumber {
                        DetailRow(title: "Phone", value: phone)
                    }
                    
                    DetailRow(title: "Email", value: employee.emailAddress)
                    
                    if let bio = employee.biography {
                        DetailRow(title: "Biography", value: bio)
                    }
                    
                    DetailRow(title: "Team", value: employee.team)
                    DetailRow(title: "Type", value: employee.employeeType.displayName)
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Employee Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadImage()
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
