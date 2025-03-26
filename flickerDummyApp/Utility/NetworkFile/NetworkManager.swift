//
//  NetworkManager.swift
//  flickerDummyApp
//
//  Created by vandana mishra on 25/03/25.
//

import Foundation

class APIService {
    
    // 1. Private constant properties for access key and base URL
    private let accessKey = "JPGuPRhheDCFkV7WjNMV8GYJTVExkPWMkzIVmnNwHo4"
    private let baseURL = "https://api.unsplash.com/photos/"
    
    // 2. Private static variable to hold the singleton instance
    static let shared = APIService()
    
    // 3. Private initializer to prevent direct instantiation
    private init() {}
    
    // 4. Method to fetch photos
    func fetchPhotos(completion: @escaping ([Photo]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)?client_id=\(accessKey)")!
        
        // 5. Perform network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                // 6. Decode the data into an array of `Photo` objects
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
