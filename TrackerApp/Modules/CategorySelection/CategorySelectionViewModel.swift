//
//  CategorySelectionViewModel.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 24.06.2025.
//

import Foundation
import CoreData

final class CategorySelectionViewModel {
    // MARK: - Output
    var categoriesDidChange: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    
    // MARK: - Properties
    private(set) var categories: [TrackerCategoryCoreData] = [] {
        didSet {
            categoriesDidChange?()
        }
    }
    
    private(set) var selectedCategory: TrackerCategoryCoreData? {
        didSet {
            if let name = selectedCategory?.name {
                onCategorySelected?(name)
            }
        }
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        categories = TrackerCategoryStore.shared.fetchAllCategories()
    }
    
    func selectCategory(at index: Int) {
        guard index < categories.count else { return }
        
        if selectedCategory?.name == categories[index].name {
            selectedCategory = nil
        } else {
            selectedCategory = categories[index]
        }
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        guard index < categories.count else { return false }
        return selectedCategory?.name == categories[index].name
    }
}
