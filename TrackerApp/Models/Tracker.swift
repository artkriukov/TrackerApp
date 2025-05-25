//
//  Tracker.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 23.05.2025.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String?
    let emoji : String?
    let schedule: [WeekDay]?
}
