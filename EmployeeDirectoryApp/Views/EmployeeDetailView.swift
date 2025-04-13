//
//  EmployeeDetailView.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI

struct EmployeeDetailView: View {
    @StateObject private var viewModel: EmployeeDetailViewModel
    
    init(employee: Employee) {
        _viewModel = StateObject(wrappedValue: EmployeeDetailViewModel(employee: employee))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Photo Section
                Group {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                    }
                }
                .onAppear {
                    viewModel.loadImage()
                }
                
                // Name and Type
                VStack(spacing: 4) {
                    Text(viewModel.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(viewModel.employeeType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Biography
                if let biography = viewModel.biography {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                        
                        Text(biography)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Contact Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Information")
                        .font(.headline)
                    
                    if let phone = viewModel.phone {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.blue)
                            Text(phone.formattedPhoneNumber())
                        }
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text(viewModel.email)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Team
                VStack(alignment: .leading, spacing: 8) {
                    Text("Team")
                        .font(.headline)
                    
                    Text(viewModel.team)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Employee Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension String {
    func formattedPhoneNumber() -> String {
        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if digits.count == 10 {
            let areaCode = String(digits.prefix(3))
            let firstPart = String(digits.dropFirst(3).prefix(3))
            let secondPart = String(digits.dropFirst(6).prefix(4))
            return "(\(areaCode)) \(firstPart)-\(secondPart)"
        }
        
        return self
    }
}
