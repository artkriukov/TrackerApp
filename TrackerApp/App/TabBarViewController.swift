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
            configureTabBar(
                with: trackersVC,
                title: "Трекеры",
                image: IconConstants.trackersIcon
            ),
            configureTabBar(
                with: statisticsVC,
                title: "Статистика",
                image: IconConstants.statisticsIcon
            ),
        ]
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
