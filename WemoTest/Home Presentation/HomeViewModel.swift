//
//  HomeViewModel.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation

class HomeViewModel {
   
    typealias Observer<T> = (T) -> Void
    
    let api: WeMoHomeAPI
    init(api: WeMoHomeAPI) {
        self.api = api
    }
    
    var onArticleLoad: Observer<[Article]>?
    
    var onOpenURL: Observer<URL>?
    
    func openURL(url: URL) {
        onOpenURL?(url)
    }
    
    func loadNews(newsCase: NewsCase) {
        
        api.loadNews(newsCase: newsCase) { result in
            
            DispatchQueue.main.async { [weak self] in
                
                switch result {
                case .success(let response):
                
                    if case .normal(let content) = response.type {
                        
                        if let content = content as? News {
                            self?.onArticleLoad?(content.articles)
                            
                        } else {
                            print("error")
                        }
                    }
                    
                case .failure(let response):
                    
                    print(response)
                    return
                }
                
            }
        }
    }
}


