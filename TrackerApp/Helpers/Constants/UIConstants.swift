//
//  ColorConstants.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

enum UIConstants {
    
    enum MainColors {
        static let mainBackgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#F2F2F7")
            case .dark: UIColor(hexString: "#1A1B22")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let secondaryBackgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#E6E8EB", alpha: 0.3)
            case .dark: UIColor(hexString: "##414141", alpha: 0.85)
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let mainTextColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#1A1B22")
            case .dark: UIColor(hexString: "#FFFFFF")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let secondaryTextColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#FFFFFF")
            case .dark: UIColor(hexString: "#1A1B22")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let buttonColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: UIColor(hexString: "#1A1B22")
            case .dark: UIColor(hexString: "#FFFFFF")
            @unknown default:
                fatalError("Unhandled userInterfaceStyle case: \(traitCollection.userInterfaceStyle). Update mainBackground color handling.")
            }
        }
        
        static let blueColor = UIColor(hexString: "#3772E7")
        static let redColor = UIColor(hexString: "#F56B6C")
        static let grayColor = UIColor(hexString: "#AEAFB4")
        static let separatorColor = UIColor(hexString: "#AEAFB4")
    }
    
    enum SelectionColors {
        static let colorSelection1 = UIColor(hexString: "FD4C49")
        static let colorSelection2 = UIColor(hexString: "FF881E")
        static let colorSelection3 = UIColor(hexString: "007BFA")
        static let colorSelection4 = UIColor(hexString: "6E44FE")
        static let colorSelection5 = UIColor(hexString: "33CF69")
        static let colorSelection6 = UIColor(hexString: "E66DD4")
        static let colorSelection7 = UIColor(hexString: "F9D4D4")
        static let colorSelection8 = UIColor(hexString: "34A7FE")
        static let colorSelection9 = UIColor(hexString: "46E69D")
        static let colorSelection10 = UIColor(hexString: "35347C")
        static let colorSelection11 = UIColor(hexString: "FF674D")
        static let colorSelection12 = UIColor(hexString: "FF99CC")
        static let colorSelection13 = UIColor(hexString: "F6C48B")
        static let colorSelection14 = UIColor(hexString: "7994F5")
        static let colorSelection15 = UIColor(hexString: "832CF1")
        static let colorSelection16 = UIColor(hexString: "AD56DA")
        static let colorSelection17 = UIColor(hexString: "8D72E6")
        static let colorSelection18 = UIColor(hexString: "2FD058")
    }
    
    enum Images {
        static let tabTrackersIcon = "tab_trackers"
        static let tabStatsIcon = "tab_stats"
        static let navAddButtonIcon = "nav_add_button"
        
        static let searchEmptyImage = "search_empty_state"
        static let trackersEmptyImage = "trackers_empty_state"
        static let statsEmptyImage = "empty_stats_state"
    }
    
    enum Icons {
        static let chevronRight = UIImage(named: "chevron")
        static let plusButton = UIImage(named: "plus")
    }
    
}
