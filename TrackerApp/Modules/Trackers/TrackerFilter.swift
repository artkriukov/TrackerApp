//
//  TrackerFilter.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import Foundation

enum TrackerFilter: Int {
    case all
    case today
    case completed
    case notCompleted

    var title: String {
        switch self {
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершённые"
        case .notCompleted: return "Незавершённые"
        }
    }
}
