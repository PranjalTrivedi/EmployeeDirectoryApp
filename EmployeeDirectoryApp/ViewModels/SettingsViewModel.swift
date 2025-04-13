//
//  SettingsViewModel.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import Foundation

class SettingsViewModel: ObservableObject {
    let studentName: String
    let studentNumber: String
    
    init(studentName: String = "Pranjal Trivedi", studentNumber: String = "1248883") {
        self.studentName = studentName
        self.studentNumber = studentNumber
    }
}
