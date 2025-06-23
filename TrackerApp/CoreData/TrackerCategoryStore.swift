//
//  TrackerCategoryStore.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 15.06.2025.
//

import CoreData

final class TrackerCategoryStore {
    static let shared = TrackerCategoryStore()
    private let context = CoreDataManager.shared.context
    
    func addCategory(_ title: String) {
        let entity = TrackerCategoryCoreData(context: context)
        entity.name = title
        CoreDataManager.shared.saveContext()
    }
    
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
}
