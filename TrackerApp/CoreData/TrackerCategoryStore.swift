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
    
    func addCategory(_ title: String) throws {
        guard !title.isEmpty else {
            throw CategoryError.emptyName
        }
        
        guard !categoryExists(title) else {
            throw CategoryError.alreadyExists
        }
        
        let entity = TrackerCategoryCoreData(context: context)
        entity.name = title
        
        try context.save()
    }
    
    private func categoryExists(_ name: String) -> Bool {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking category existence: \(error)")
            return false
        }
    }
    
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func printAllCategories() {
        let categories = fetchAllCategories()
        print("📋 Все категории (\(categories.count)):")
        categories.forEach { print("- \($0.name ?? "Без названия")") }
    }
}

extension TrackerCategoryStore {
    enum CategoryError: Error {
        case emptyName
        case alreadyExists
        case coreDataError(Error)
        
        var localizedDescription: String {
            switch self {
            case .emptyName:
                return "Название категории не может быть пустым"
            case .alreadyExists:
                return "Категория с таким именем уже существует"
            case .coreDataError(let error):
                return "Ошибка базы данных: \(error.localizedDescription)"
            }
        }
    }
}
