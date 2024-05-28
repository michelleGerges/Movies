//
//  URLImage.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import UIKit

class URLImageView: UIImageView {
    
    static var images = NSCache<NSString, UIImage>()
    
    var url: URL?
    func load(url: URL?) {
        
        guard let url = url, url != self.url else { return }
        
        if let image = Self.images.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }
        
        self.image = nil
        self.url = url
        
        Task.detached {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            guard let result = try? await URLSession.shared.data(for: request) else {
                return
            }
            
            if let image = UIImage(data: result.0) {
                DispatchQueue.main.async {
                    Self.images.setObject(image, forKey: url.absoluteString as NSString)
                    if url == self.url {
                        self.image = image
                    }
                }
            }
        }
    }
}
