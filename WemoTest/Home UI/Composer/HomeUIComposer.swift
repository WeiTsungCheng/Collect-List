//
//  HomeUIComposer.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import Foundation

final class HomeUIComposer {
    private init() {}
    
    public static func homeComposedWith(api: WeMoHomeAPI, imageLoader: ImageLoader, storageManager: StorageManager) -> HomeViewController {
        
        let homeViewModel = HomeViewModel(api: api)
        
        let viewController = HomeViewController()
        viewController.viewModel = homeViewModel
        
        homeViewModel.onArticleLoad = adaptFeedToCellControllers(forwardingTo: viewController, imageLoader: imageLoader, storageManager: storageManager)
        
        return viewController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: HomeViewController, imageLoader: ImageLoader, storageManager: StorageManager) -> ([Article]) -> Void {
        return { [weak controller] articles in
            controller?.tableModel = articles.map { model in ArticleCellController(viewModel: ArticleCellViewModel(model: model, imageLoader: imageLoader, storageManager: storageManager)
            )
                
            }
        }
    }
}
