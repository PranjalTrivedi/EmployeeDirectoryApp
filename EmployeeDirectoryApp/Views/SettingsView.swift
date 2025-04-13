//
//  SettingsView.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("App Information")) {
                HStack {
                    Text("Developer")
                    Spacer()
                    Text(viewModel.studentName)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Student Number")
                    Spacer()
                    Text(viewModel.studentNumber)
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("About")) {
                Text("Employee Directory v1.0")
                    .foregroundColor(.secondary)
                Text("This app displays company employee information fetched from a remote server.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
    }
}
