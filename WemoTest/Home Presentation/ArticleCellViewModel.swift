//
//  ArticleCellViewModel.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/7.
//

import Foundation
import UIKit

class ArticleCellViewModel {
    
    typealias Observer<T> = (T) -> Void
    private let model: Article
    private let imageLoader: ImageLoader
    private let storageManager: StorageManager
    
    init(model: Article, imageLoader: ImageLoader, storageManager: StorageManager) {
        self.model = model
        self.imageLoader = imageLoader
        self.storageManager = storageManager
    }
    
    var name: String {
        return model.source.name
    }
    
    var titile: String {
        return model.title
    }
    
    var description: String? {
        return model.description
    }
    
    var time: String {
        return model.publishedAt
    }
    
    var url: URL {
        return model.url
    }
    
    var isLike: Bool = false
    
    var onImageLoad: Observer<UIImage>?
    
    
    func loadImage() {
        
        guard let url = model.urlToImage else {
            return
        }
        
        self.imageLoader.load(url: url) { [weak self] result in
            self?.handle(result)
        }
        
    }
    
    private func handle(_ result: ImageLoader.Result) {
        
        if case let .success(image) = result {
            onImageLoad?(image)
        }
    }
    
    func storeArticle() {
        
        if var articles: [Article] = StorageManager.shared.loadObjectArray(for: .articles) {
            
            let isContain = articles.contains(where: { element in
                return model.title == element.title
            })
            
            if isContain == false {
                articles.append(model)
                StorageManager.shared.saveObjectArray(for: .articles, value: articles)
                
            } else {
                let filteredArticles = articles.filter({ element in
                    return model.title != element.title
                })
                
                StorageManager.shared.saveObjectArray(for: .articles, value: filteredArticles)
            }
            
        } else {
            StorageManager.shared.saveObjectArray(for: .articles, value: [model])
        }
    }
    
    
}
