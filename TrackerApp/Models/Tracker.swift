//
//  Tracker.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 23.05.2025.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDay>
    let categoryName: String?
    let createdAt: Date
    let isPinned: Bool
}
