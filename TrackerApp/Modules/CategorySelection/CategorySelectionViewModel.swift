//
//  CategorySelectionViewModel.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 24.06.2025.
//

import Foundation
import CoreData

import Foundation
import CoreData

final class CategorySelectionViewModel {
    
    // MARK: - Nested Types
    struct CategoryViewModel {
        let name: String
        let isSelected: Bool
    }
    
    // MARK: - Output Properties
    var categoriesDidChange: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    
    // MARK: - Private Properties
    private var coreDataCategories: [TrackerCategoryCoreData] = []
    private var selectedCategory: TrackerCategoryCoreData? {
        didSet {
            if let name = selectedCategory?.name {
                onCategorySelected?(name)
            }
            updateViewModels()
        }
    }
    
    // MARK: - Public Properties
    private(set) var categories: [CategoryViewModel] = []
    
    func loadCategories() {
        do {
            coreDataCategories = try TrackerCategoryStore.shared.fetchAllCategories()
            updateViewModels()
        } catch {
            print("Ошибка загрузки категорий: \(error.localizedDescription)")
            coreDataCategories = []
            updateViewModels()
        }
    }
    
    func selectCategory(at index: Int) {
        guard index < coreDataCategories.count else { return }
        selectedCategory = coreDataCategories[index]
    }

    func isCategorySelected(at index: Int) -> Bool {
        guard index < coreDataCategories.count else { return false }
        return coreDataCategories[index].name == selectedCategory?.name
    }
    
    
    private func updateViewModels() {
        categories = coreDataCategories.map { category in
            CategoryViewModel(
                name: category.name ?? "Без названия",
                isSelected: category.name == selectedCategory?.name
            )
        }
        categoriesDidChange?()
    }
}
