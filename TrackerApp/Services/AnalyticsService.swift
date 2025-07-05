//
//  AnalyticsService.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 05.07.2025.
//

import Foundation
import AppMetricaCore

enum AnalyticsService {
    
    static func report(event: String, screen: String, item: String? = nil) {
    
        var params: [String: Any] = ["screen": screen, "event": event]
        if let item = item {
            params["item"] = item
        }
        
        print("ANALYTICS EVENT: \(params)")
        
        AppMetrica.reportEvent(name: "ui_event", parameters: params) { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}
