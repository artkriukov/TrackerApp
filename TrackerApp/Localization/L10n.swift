//
//  L10n.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import Foundation

enum L10n {
    static let trackersTitle = NSLocalizedString("trackers_title", comment: "")
    static let filtersButton = NSLocalizedString("filters_button", comment: "")
    static let searchPlaceholder = NSLocalizedString("search_placeholder", comment: "")
    static let emptyStateText = NSLocalizedString("empty_state_text", comment: "")
    static let notFoundText = NSLocalizedString("not_found_text", comment: "")
    static let editAction = NSLocalizedString("edit_action", comment: "")
    static let deleteAction = NSLocalizedString("delete_action", comment: "")
    static let deleteAlertTitle = NSLocalizedString("delete_alert_title", comment: "")
    static let deleteAlertConfirm = NSLocalizedString("delete_alert_confirm", comment: "")
    static let deleteAlertCancel = NSLocalizedString("delete_alert_cancel", comment: "")
    static let statisticsTab = NSLocalizedString("statistics_tab", comment: "")
    
    static func dayString(for value: Int) -> String {
        let remainder10 = value % 10
        let remainder100 = value % 100
        let key: String
        if remainder10 == 1 && remainder100 != 11 {
            key = "day_one"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            key = "day_few"
        } else {
            key = "day_other"
        }
        let localized = NSLocalizedString(key, comment: "")
        return "\(value) \(localized)"
    }
}
