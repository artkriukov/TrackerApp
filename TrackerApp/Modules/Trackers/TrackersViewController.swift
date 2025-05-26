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
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var searchController: UISearchController = {
        let element = UISearchController(searchResultsController: nil)
        element.searchBar.placeholder = "Поиск"
        element.searchBar.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 167, height: 148)
        
        let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
        element.dataSource = self
        element.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.trackerCollectionViewCell)
        element.showsVerticalScrollIndicator = false
        element.backgroundColor = UIConstants.MainColors.mainBackground
        element.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(trackersCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersCollectionView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 24
                ),
            trackersCollectionView.leadingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
            trackersCollectionView.trailingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                ),
            trackersCollectionView.bottomAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -2
                )
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.trackerCollectionViewCell,
            for: indexPath
        )
        
        return cell
    }

    
}
