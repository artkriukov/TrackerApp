//
//  TrackerRecordStore.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 15.06.2025.
//

import Foundation
import CoreData

final class TrackerRecordStore {
    static let shared = TrackerRecordStore()
    private let context = CoreDataManager.shared.context
    
    private init() {}
    
    // MARK: - Add Record
    
    func addRecord(for id: UUID, on date: Date) {
        let entity = TrackerRecordCoreData(context: context)
        entity.trackerId = id
        entity.date = date
        
        guard let trackerEntity = TrackerStore.shared.fetchTrackerEntity(by: id) else {
            print("Не удалось найти TrackerEntity")
            return
        }
        
        entity.tracker = trackerEntity
        
        CoreDataManager.shared.saveContext()
    }
    
    func addRecord(_ record: TrackerRecord) {
        addRecord(for: record.trackerId, on: record.date)
    }
    
    // MARK: - Remove Record
    
    func removeRecord(for id: UUID, on date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            assertionFailure("Failed to calculate next day")
            return
        }
        
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", id as CVarArg),
            NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, nextDay as CVarArg)
        ])
        
        do {
            let results = try context.fetch(request)
            if let entityToDelete = results.first {
                context.delete(entityToDelete)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            assertionFailure("Failed to fetch tracker record: \(error.localizedDescription)")
        }
    }
    
    
    func deleteRecord(_ record: TrackerRecord) {
        removeRecord(for: record.trackerId, on: record.date)
    }
    
    // MARK: - Fetch Records
    
    func fetchAllRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        do {
            let result = try context.fetch(request)
            return result.compactMap { entity in
                guard let id = entity.trackerId, let date = entity.date else {
                    return nil
                }
                return TrackerRecord(trackerId: id, date: date)
            }
        } catch {
            return []
        }
    }
    
    
    func isTrackerCompleted(_ trackerID: UUID, on date: Date) -> Bool {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", trackerID as CVarArg),
            NSPredicate(format: "date == %@", date as CVarArg)
        ])
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            return false
        }
    }
    
}

