//
//  EmployeeType.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

enum EmployeeType: String, Codable {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contractor = "CONTRACTOR"
    
    var displayName: String {
        switch self {
        case .fullTime: return "Full-time"
        case .partTime: return "Part-time"
        case .contractor: return "Contractor"
        }
    }
}
