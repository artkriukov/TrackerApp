//
//  WeekDay.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 23.05.2025.
//

import Foundation

enum WeekDay: String, CaseIterable {
    case monday = "1"
    case tuesday = "2"
    case wednesday = "3"
    case thursday = "4"
    case friday = "5"
    case saturday = "6"
    case sunday = "7"
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        case 7: self = .sunday
        default: return nil
        }
    }
}

extension WeekDay {
    var fullName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
}
