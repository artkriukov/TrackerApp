//
//  Extension+TrackerCoreData.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 21.06.2025.
//

import UIKit

extension TrackerCoreData {
    func toTracker() -> Tracker? {
        
        guard let id = self.id else {
            print("🔴 Ошибка: id отсутствует")
            return nil
        }
        guard let name = self.name else {
            print("🔴 Ошибка: name отсутствует")
            return nil
        }
        guard let emoji = self.emoji else {
            print("🔴 Ошибка: emoji отсутствует")
            return nil
        }
        guard let colorHex = self.color else {
            print("🔴 Ошибка: color отсутствует")
            return nil
        }
        guard let categoryName = self.category?.name else {
            print("🔴 Ошибка: категория отсутствует")
            return nil
        }
        guard let createdAt = self.createdAt else {
            print("🔴 Ошибка: createdAt отсутствует")
            return nil
        }

        
        var scheduleSet = Set<WeekDay>()
        if let data = self.schedule {
            if let rawValues = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSString.self],
                from: data
            ) as? [String] {
                scheduleSet = Set(rawValues.compactMap { WeekDay(rawValue: $0) })
            } else {
            }
        } else {
            print("🔴 Расписание отсутствует")
        }

        guard let color = UIColor(hex: colorHex) else { return nil }

        
        let tracker = Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: scheduleSet,
            categoryName: categoryName,
            createdAt: createdAt,
            isPinned: self.isPinned
        )
        
        return tracker
    }
}
