//
//  SceneDelegate.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/6.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeRootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UIViewController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVC(), favoriteVC()]
        return tabBar
    }
    
    func homeVC() -> UIViewController {
        let api = WeMoHomeAPI()
        let imageLoader = ImageLoader()
        let storageManager = StorageManager.shared
        let vc = UINavigationController(rootViewController: HomeUIComposer.homeComposedWith(api: api, imageLoader: imageLoader, storageManager: storageManager))
        vc.isNavigationBarHidden = true
        vc.tabBarItem.title = "首頁"
        vc.tabBarItem.image = UIImage(named: "star.fill")
        return vc
    }
    
    func favoriteVC() -> UIViewController {
        let vc =  UIViewController()
        vc.view.backgroundColor = .white
        vc.tabBarItem.title = "收藏"
        vc.tabBarItem.image = UIImage(named: "star.fill")
        return vc
    }
    
    
    
    
    
}

