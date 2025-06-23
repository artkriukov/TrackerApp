//
//  Extension+Array.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 15.06.2025.
//

import Foundation

extension Array where Element == WeekDay {
    func toString() -> String {
        self.map { $0.rawValue }.joined(separator: ",")
    }
    
    static func from(string: String) -> [WeekDay] {
        string.components(separatedBy: ",")
            .compactMap { WeekDay(rawValue: $0) }
    }
}
