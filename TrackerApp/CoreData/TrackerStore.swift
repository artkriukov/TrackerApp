//
//  TrackerStore.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 15.06.2025.
//

import UIKit
import CoreData

final class TrackerStore {
    static let shared = TrackerStore()
    private let context = CoreDataManager.shared.context
    
    private init() {}
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return controller
    }()
    
    // MARK: - Add Tracker
    
    func addTracker(_ tracker: Tracker, categoryTitle: String, createdAt: Date) {
        let entity = TrackerCoreData(context: context)
        entity.id = tracker.id
        entity.name = tracker.name
        entity.emoji = tracker.emoji
        entity.color = tracker.color.toHexString()
        entity.createdAt = createdAt
        entity.isPinned = tracker.isPinned
        
        if let categoryEntity = fetchCategoryEntity(by: categoryTitle) {
            entity.category = categoryEntity
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.name = categoryTitle
            entity.category = newCategory
        }
        
        let rawValues = tracker.schedule.map { $0.rawValue }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: rawValues, requiringSecureCoding: true)
            entity.schedule = data
        } catch {
            print("Ошибка при сохранении расписания: \(error)")
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: - Update Tracker
    
    func updateTracker(_ tracker: Tracker, categoryTitle: String) {
        guard let entity = fetchTrackerEntity(by: tracker.id),
              let category = fetchCategoryEntity(by: categoryTitle) else {
            return
        }
        
        entity.name = tracker.name
        entity.emoji = tracker.emoji
        entity.color = tracker.color.toHexString()
        entity.createdAt = tracker.createdAt
        entity.isPinned = tracker.isPinned
        
        let rawValues = tracker.schedule.map { $0.rawValue }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: rawValues, requiringSecureCoding: true)
            entity.schedule = data
        } catch {
            print("Ошибка при сохранении расписания: \(error)")
        }
        
        entity.category = category
        CoreDataManager.shared.saveContext()
    }
    
    
    func togglePin(for tracker: Tracker) {
        if let entity = fetchTrackerEntity(by: tracker.id) {
            entity.isPinned.toggle()
            CoreDataManager.shared.saveContext()
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        if let entity = fetchTrackerEntity(by: tracker.id) {
            context.delete(entity)
            CoreDataManager.shared.saveContext()
            
            _ = TrackerRecordStore.shared
                .fetchAllRecords()
                .filter { $0.trackerId == tracker.id }
        }
    }
    
    // MARK: - Fetch Trackers
    
    func fetchAllTrackers() -> [TrackerCoreData] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    // MARK: - Fetch Categories
    
    func fetchAllCategories() -> [TrackerCategory] {
        var result: [TrackerCategory] = []
        
        context.performAndWait {
            let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
            
            do {
                let categoryEntities = try context.fetch(request)
                
                result = categoryEntities.compactMap { categoryEntity in
                    guard let trackersSet = categoryEntity.trackers else {
                        return nil
                    }
                    
                    let trackers = trackersSet.compactMap { object -> Tracker? in
                        guard let trackerCoreData = object as? TrackerCoreData else { return nil }
                        return trackerCoreData.toTracker()
                    }
                    
                    return TrackerCategory(
                        title: categoryEntity.name ?? "Без имени",
                        trackers: trackers
                    )
                }
            } catch {
                result = []
            }
        }
        
        return result
    }
    
    // MARK: - Helpers
    private func saveSchedule(_ schedule: Set<WeekDay>) -> Data? {
        let rawValues = schedule.map { $0.rawValue }
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: rawValues, requiringSecureCoding: true)
        } catch {
            return nil
        }
    }
    
    func fetchTrackerEntity(by id: UUID) -> TrackerCoreData? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
    
    private func fetchCategoryEntity(by title: String) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", title)
        return try? context.fetch(request).first
    }
    
}

