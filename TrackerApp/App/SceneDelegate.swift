//
//  SceneDelegate.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
//        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            window.rootViewController = OnboardingViewController()
//        } else {
//            window.rootViewController = TabBarViewController() 
//        }
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
