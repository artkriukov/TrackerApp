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
            print("TrackerEntity: id отсутствует")
            return nil
        }
        guard let name = self.name else { 
            print("TrackerEntity: name отсутствует")
            return nil
        }
        guard let emoji = self.emoji else {
            print("TrackerEntity: emoji отсутствует")
            return nil
        }
        guard let colorHex = self.color else {
            print("TrackerEntity: colorHex отсутствует")
            return nil
        }
        guard let categoryName = self.category?.name else {
            print("TrackerEntity: категория отсутствует")
            return nil
        }
        guard let createdAt = self.createdAt else {
            print("TrackerEntity: createdAt отсутствует")
            return nil
        }

        var scheduleSet = Set<WeekDay>()
        if let data = self.schedule {
            if let rawValues = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSString.self],
                from: data
            ) as? [String] {
                scheduleSet = Set(rawValues.compactMap { WeekDay(rawValue: $0) })
            }
        }

        return Tracker(
            id: id,
            name: name,
            color: UIColor(hex: colorHex),
            emoji: emoji,
            schedule: scheduleSet,
            categoryName: categoryName,
            createdAt: createdAt,
            isPinned: self.isPinned
        )
    }
}
