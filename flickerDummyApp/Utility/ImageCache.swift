//
//  ImageCache.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 25/03/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    // In-memory cache
    private var memoryCache = NSCache<NSString, UIImage>()
    
    // to store images on disk
    private let fileManager = FileManager.default
    private lazy var cacheDirectory: URL = {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls.first!.appendingPathComponent("ImageCache")
    }()
    
    init() {
        // Create directory for image cache if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // store image from in-memory cache
    func cachedImage(forKey key: String) -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // If not in memory cache, try to fetch from disk cache
        if let cachedImage = loadImageFromDisk(forKey: key) {
            return cachedImage
        }
        
        return nil
    }
    
    // Save image to in-memory cache
    func cacheImage(_ image: UIImage, forKey key: String, targetSize: CGSize? = nil) {
        // Resize the image before caching if a target size is provided
        let resizedImage: UIImage
        if let targetSize = targetSize {
            resizedImage = resizeImage(image, to: targetSize)
        } else {
            resizedImage = image
        }
        
        // Save to memory cache
        memoryCache.setObject(resizedImage, forKey: key as NSString)
        
        // Save to disk cache
        saveImageToDisk(resizedImage, forKey: key)
    }
    
    // Get the file URL for the image on disk
    private func getFilePath(forKey key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }
    
    // Load image from disk cache
    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let filePath = getFilePath(forKey: key)
        
        if let imageData = try? Data(contentsOf: filePath),
           let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
    
    // Save image to disk
    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        let filePath = getFilePath(forKey: key)
        
        if let imageData = image.pngData() {
            try? imageData.write(to: filePath)
        }
    }
    
    // Resize image to fit the target size
    private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
