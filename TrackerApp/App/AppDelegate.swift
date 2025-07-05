//
//  AppDelegate.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit
import AppMetricaCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let configuration = AppMetricaConfiguration(apiKey: MetricsConstants.apiKey) else {
            return true
        }
        
        AppMetrica.activate(with: configuration)
        
        return true
    }
}

