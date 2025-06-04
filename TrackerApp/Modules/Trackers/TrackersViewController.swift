//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    
    private var categories: [TrackerCategory] = [] {
        didSet {
            filterTrackers(for: currentDate)
        }
    }
    
    private var currentDate = Date() {
        didSet {
            filterTrackers(for: currentDate)
        }
    }
    
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
        element.isHidden = true
        element.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        element.backgroundColor = UIConstants.MainColors.blueColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let element = UIDatePicker()
        element.datePickerMode = .date
        element.preferredDatePickerStyle = .compact
        element.locale = Locale(identifier: "ru_RU")
        element.addAction(
            UIAction { [weak self] _ in
                self?.dateChanged()
            }, for: .valueChanged
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        setupViews()
        setupConstraints()
        setupNavigation()
        updateEmptyStateVisibility()
    }
    
    // MARK: - Private Methods
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        let currentWeekDay = WeekDay.allCases[adjustedWeekday - 1]
        
        filteredCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                
                guard let schedule = tracker.schedule else { return true }
             
                return schedule.contains(currentWeekDay)
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        trackersCollectionView.reloadData()
        updateEmptyStateVisibility()
    }
    
    private func dateChanged() {
        currentDate = datePicker.date
    }
    
    private func updateEmptyStateVisibility() {
        let hasTrackers = !filteredCategories.isEmpty
        emptyStateView.isHidden = hasTrackers
        //        filterButton.isHidden = !hasTrackers
        trackersCollectionView.isHidden = !hasTrackers
        
        print("Empty state visibility: \(emptyStateView.isHidden ? "hidden" : "visible")")
        print("Number of categories: \(categories.count)")
    }
    
    private func toggleTrackerCompletion(_ tracker: Tracker) {
        let record = TrackerRecord(trackerId: tracker.id, date: currentDate)
        
        if let index = completedTrackers.firstIndex(where: { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
            completedTrackers.remove(at: index)
        } else {
            guard currentDate <= Date() else { return }
            completedTrackers.append(record)
        }
        
        trackersCollectionView.reloadData()
    }
    
    private func setupNavigation() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTracker)
        )
        addButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = addButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func addTracker() {
        let typeSelectionVC = TrackerTypeSelectionViewController(trackersViewController: self)
        let navController = UINavigationController(rootViewController: typeSelectionVC)
        present(navController, animated: true)
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    func completeTracker(id: String) {
        guard let uuid = UUID(uuidString: id) else { return }
        let record = TrackerRecord(trackerId: uuid, date: currentDate)
        completedTrackers.append(record)
        trackersCollectionView.reloadData()
    }
    
    func uncompleteTracker(id: String) {
        guard let uuid = UUID(uuidString: id) else { return }
        completedTrackers.removeAll { record in
            record.trackerId == uuid && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
        trackersCollectionView.reloadData()
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
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCellIdentifiers.trackerCollectionViewCell,
            for: indexPath
        ) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let isCompletedToday = completedTrackers.contains { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        
        cell.configureCell(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            currentDate: currentDate
        )
        cell.delegate = self
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
        filteredCategories.count
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

extension TrackersViewController: NewEventViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, in categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            categories[index].trackers.append(tracker)
        } else {
            let category = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(category)
        }
        
        filterTrackers(for: currentDate)
        trackersCollectionView.reloadData()
        updateEmptyStateVisibility()
    }
}
