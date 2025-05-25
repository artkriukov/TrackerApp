//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var categories: [TrackerCategory]?
    
    // MARK: - UI
    private lazy var emptyStateView: UIStackView = {
        guard let image = UIImage(named: UIConstants.Images.trackersEmptyImage) else {
            return UIStackView()
        }
        let stackView = FactoryUI.shared.makeEmptyStateView(
            image: image,
            text: "Что будем отслеживать?"
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
        private lazy var searchController: UISearchController = {
            let element = UISearchController(searchResultsController: nil)
            element.searchBar.placeholder = "Поиск"
            element.searchBar.translatesAutoresizingMaskIntoConstraints = false
            return element
        }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        setupViews()
        setupConstraints()
    }
}

private extension TrackersViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackground
        
        view.addSubview(emptyStateView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
        ])
    }
}
