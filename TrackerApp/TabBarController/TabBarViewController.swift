//
//  TabBarViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

enum Screens {
    case trackers
    case statistics
}

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
                screen: .trackers,
                title: "Трекеры",
                image: UIConstants.Images.tabTrackersIcon
            ),
            configureNavBar(
                with: statisticsVC,
                screen: .statistics,
                title: "Статистика",
                image: UIConstants.Images.tabStatsIcon
            ),
        ]
    }
    
    private func configureNavBar(
        with viewController: UIViewController,
        screen: Screens,
        title: String,
        image: String
    ) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        
        viewController.tabBarItem.image = UIImage(named: image)
        viewController.title = title
        
        switch screen {
        case .trackers:
            
            let datePicker = makeDatePicker()
            
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
            
        case .statistics:
            break
        }
        
        return navController
    }
}

private extension TabBarViewController {
    func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        
        return datePicker
    }
    
    @objc func presentTrackerTypeSelection() {
        let trackerTypeVC = TrackerTypeSelectionViewController(
            trackersViewController: TrackersViewController()
        )
        let navController = UINavigationController(rootViewController: trackerTypeVC)
        present(navController, animated: true)
    }
}
