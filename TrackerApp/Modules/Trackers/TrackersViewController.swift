//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Some titele",
            trackers: [Tracker(
                id: UUID(),
                name: "Some name",
                color: .blue,
                emoji: "🚀"
                //    schedule: 5
            )]
        ),
        TrackerCategory(
            title: "Some titele2",
            trackers: [Tracker(
                id: UUID(),
                name: "Some name2",
                color: .red,
                emoji: "🚀"
                //    schedule: 5
            )]
        ),
    ]
    
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
        element.delegate = self
        element.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifiers.trackerCollectionViewCell)
        element.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewCellIdentifiers.headerSupplementaryView
        )
        element.showsVerticalScrollIndicator = false
        element.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var filterButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setTitle("Фильтры", for: .normal)
        element.layer.cornerRadius = 16
        element.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        element.backgroundColor = UIConstants.MainColors.blueColor
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
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        
        view.addSubview(emptyStateView)
        view.addSubview(trackersCollectionView)
        view.addSubview(filterButton)
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
                ),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.trackerCollectionViewCell,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        cell.configureCell(with: tracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionViewCellIdentifiers.headerSupplementaryView,
            for: indexPath
        ) as? SupplementaryView
        
        header?.titleLabel.text = categories[indexPath.section].title
        
        return header ?? UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categories.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20) // высота хедера
    }
    
    // Дополнительно можно настроить отступы
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
