//
//  ImageLoader.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/7.
//
import Foundation
import UIKit

final class ImageLoader {
    
    struct HTTPError: Error {
        let code: Code
        enum Code {
            case noData
        }
    }
    
    static let shared = ImageLoader()
    
    let imageCache = NSCache<NSURL, UIImage>()
    
    typealias Result = Swift.Result<UIImage, Error>
    
    func load(url: URL, completion:  @escaping (Result) -> Void) {
        
        if let image = imageCache.object(forKey: url as NSURL) {
            completion(.success(image))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completion(.success(image))
                
            } else {
                
                if let error = error {
                    completion(.failure(error))
                }
                completion(.failure(HTTPError(code: .noData)))
            }
            
        }.resume()
        
    }
    
}

