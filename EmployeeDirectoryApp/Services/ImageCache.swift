//
//  ImageCache.swift
//  EmployeeDirectoryApp
//
//  Created by Pranjal Trivedi on 2025-04-13.
//

import UIKit
import SwiftUI

protocol ImageCacheProtocol {
    func getImage(for key: String) -> UIImage?
    func setImage(_ image: UIImage, for key: String)
}

class ImageCache: ImageCacheProtocol {
    private let cache = NSCache<NSString, UIImage>()
    
    func getImage(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

class DiskImageCache {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("EmployeeImages")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func getImage(for key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}

class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    private let memoryCache = ImageCache()
    private let diskCache = DiskImageCache()
    private let userDefaults = UserDefaults.standard
    private let employeesKey = "cachedEmployees"
    
    private init() {}
    
    // MARK: - Image Caching
    func getImage(for urlString: String) -> UIImage? {
        if let memoryImage = memoryCache.getImage(for: urlString) {
            return memoryImage
        }
        
        if let diskImage = diskCache.getImage(for: urlString) {
            memoryCache.setImage(diskImage, for: urlString)
            return diskImage
        }
        
        return nil
    }
    
    func saveImage(_ image: UIImage, for urlString: String) {
        memoryCache.setImage(image, for: urlString)
        diskCache.setImage(image, for: urlString)
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

protocol CacheManagerProtocol {
    func getImage(for urlString: String) -> UIImage?
    func saveImage(_ image: UIImage, for urlString: String)
    func getEmployees() -> [Employee]?
    func saveEmployees(_ employees: [Employee])
}
