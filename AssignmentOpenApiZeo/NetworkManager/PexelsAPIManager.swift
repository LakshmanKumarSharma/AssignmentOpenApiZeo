//
//  PexelsAPIManager.swift
//  AssignmentOpenApiZeo
//
//  Created by LAKSHMAN on 20/03/25.
//

import UIKit

// API Manager for Fetching & Caching Images
class PexelsAPIManager {
    
    static let shared = PexelsAPIManager()
    private let apiKey = "BntzrOmTFbpGxqUCZSt49yUVFhM0BmqvaxmcUmx9AooiHliff8OAu1dj"
    private let baseURL = "https://api.pexels.com/v1/search"
    private let cache = NSCache<NSString, UIImage>()

    // Fetch Image URLs based on search query
    func fetchImages(query: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "\(baseURL)?query=\(query)&per_page=20") else { return }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let photos = json["photos"] as? [[String: Any]] {
                let imageURLs = photos.compactMap { ($0["src"] as? [String: Any])?["medium"] as? String }
                DispatchQueue.main.async { completion(imageURLs) }
            }
        }.resume()
    }

    // Fetch & Cache Image
    func fetchImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }

        guard let imageURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSString)
                DispatchQueue.main.async { completion(image) }
            }
        }.resume()
    }
}
