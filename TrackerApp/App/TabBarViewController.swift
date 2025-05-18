//
//  TabBarViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()
        
        viewControllers = [
            configureNavBar(
                with: trackersVC,
                title: "Трекеры",
                image: ImageConstants.tabTrackersIcon
            ),
            configureTabBar(
                with: statisticsVC,
                title: "Статистика",
                image: ImageConstants.tabStatsIcon
            ),
        ]
    }
    
    private func configureNavBar(
        with viewController: UIViewController,
        title: String,
        image: String
    ) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        
        viewController.tabBarItem.image = UIImage(named: image)
        viewController.title = title
        
        let leftButton = UIBarButtonItem(
            image: UIImage(named: ImageConstants.navAddButtonIcon),
            style: .plain,
            target: self,
            action: nil // #selector(...)
        )
        
        leftButton.tintColor = .label
        viewController.navigationItem.leftBarButtonItem = leftButton
        
        return navController
    }
    
    private func configureTabBar(
        with viewController: UIViewController,
        title: String,
        image: String
    ) -> UIViewController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: image)
        
        return viewController
    }
}

// использовать enum - case это экран если трэкер - то есть кнопка если сатистика но нет кнопки 
