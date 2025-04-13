//
//  ImageCache.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import UIKit
import CryptoKit

class ImageCache {
    static let shared = ImageCache()
    
    // Image caching
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    // Employee data caching
    private let userDefaults = UserDefaults.standard
    private let employeesKey = "cachedEmployees"
    
    private init() {
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Image Caching Methods
    func getImage(for urlString: String) -> UIImage? {
        if let image = memoryCache.object(forKey: urlString as NSString) {
            return image
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(urlString.sha256)
        if fileManager.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: urlString as NSString)
            return image
        }
        
        return nil
    }
    
    func saveImage(_ image: UIImage, for urlString: String) {
        memoryCache.setObject(image, forKey: urlString as NSString)
        let fileURL = cacheDirectory.appendingPathComponent(urlString.sha256)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    // MARK: - Employee Data Caching
    func getEmployees() -> [Employee]? {
        guard let data = userDefaults.data(forKey: employeesKey) else { return nil }
        return try? JSONDecoder().decode([Employee].self, from: data)
    }
    
    func saveEmployees(_ employees: [Employee]) {
        if let data = try? JSONEncoder().encode(employees) {
            userDefaults.set(data, forKey: employeesKey)
        }
    }
}

extension String {
    var sha256: String {
        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
