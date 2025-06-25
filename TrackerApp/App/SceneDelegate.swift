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
        self.window = window
        
        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            let onboardingVC = OnboardingViewController()
            onboardingVC.onFinish = { [weak self] in
                UserDefaults.standard.set(true, forKey: "onboardingCompleted")
                self?.setRootViewController(TabBarViewController())
            }
            window.rootViewController = onboardingVC
        } else {
            window.rootViewController = TabBarViewController()
        }
        
        window.makeKeyAndVisible()
    }
    
    private func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = viewController
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }
}
