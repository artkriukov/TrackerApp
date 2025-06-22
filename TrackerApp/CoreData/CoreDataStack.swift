//
//  CoreDataStack.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 14.06.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {
        registerTransformers()
    }

    // MARK: - Core Data Stack

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Ошибка при загрузке хранилища Core Data: \(error)")
            }
        }
        return container
    }()

    // MARK: - Transformer Registration

    private func registerTransformers() {
        ValueTransformer.setValueTransformer(
            ScheduleTransformer(),
            forName: NSValueTransformerName("ScheduleTransformer")
        )
    }

    // MARK: - Saving

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

