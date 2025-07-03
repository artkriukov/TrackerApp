//
//  TrackersViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit
import CoreData

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private var completedTrackers: [TrackerRecord] = []
    private var filteredCategories: [TrackerCategory] = []
    private var currentFilter: TrackerFilter = .all {
        didSet {
            applyFilter()
            updateFilterButtonAppearance()
        }
    }
    
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
    
    private var emptyStateLabel: UILabel?
    // MARK: - UI
    private lazy var emptyStateView: UIStackView = {
        guard let image = UIImage(named: Asset.Images.trackersEmptyImage) else {
            return UIStackView()
        }
        let stackView = FactoryUI.shared.makeEmptyStateView(
            image: image,
            text: "Что будем отслеживать?"
        )
        if let label = stackView.arrangedSubviews.last as? UILabel {
            self.emptyStateLabel = label
        }
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
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 16
        
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
        element.backgroundColor = Asset.MainColors.mainBackgroundColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var filterButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setTitle("Фильтры", for: .normal)
        element.layer.cornerRadius = 16
        element.isHidden = true
        element.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        element.backgroundColor = Asset.MainColors.blueColor
        element.addAction(UIAction { _ in
            self.showFilterModal()
        }, for: .touchUpInside)
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

        refreshData()
        
        if let saved = UserDefaults.standard.value(forKey: "selectedFilter") as? Int,
           let filter = TrackerFilter(rawValue: saved) {
            currentFilter = filter
        } else {
            currentFilter = .all
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedCategories = TrackerStore.shared.fetchAllCategories()
            
            DispatchQueue.main.async {
                self.categories = loadedCategories
                self.filterTrackers(for: self.currentDate)
            }
        }
        
        refreshData()
    }


    
    // MARK: - Private Methods
    
    private func showFilterModal() {
        let filterVC = FilterSelectionViewController(selectedFilter: currentFilter)
        filterVC.delegate = self
        let nav = UINavigationController(rootViewController: filterVC)
        present(nav, animated: true)
    }
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        let currentWeekDay = WeekDay.allCases[adjustedWeekday - 1]

        let completedIds = completedTrackers
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .map { $0.trackerId }

        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let contains = tracker.schedule.contains(currentWeekDay)
                switch currentFilter {
                case .all, .today:
                    return contains
                case .completed:
                    return contains && completedIds.contains(tracker.id)
                case .notCompleted:
                    return contains && !completedIds.contains(tracker.id)
                }
            }
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }

        trackersCollectionView.reloadData()
        updateEmptyStateVisibility()
    }
    
    private func dateChanged() {
        currentDate = datePicker.date
    }
    
    private func setEmptyStateText(_ text: String) {
        emptyStateLabel?.text = text
    }
    
    private func refreshData() {
        DispatchQueue.global().async {
            let loadedCategories = TrackerStore.shared.fetchAllCategories()
            DispatchQueue.main.async {
                self.categories = loadedCategories
                self.filterTrackers(for: self.currentDate)
                self.updateEmptyStateVisibility()
            }
        }
    }
    
    private func updateEmptyStateVisibility() {
        let hasAnyTrackers = !categories.flatMap { $0.trackers }.isEmpty
        let hasTrackers = !filteredCategories.isEmpty

        trackersCollectionView.isHidden = !hasTrackers
        filterButton.isHidden = false

        if hasTrackers {
            emptyStateView.isHidden = true
        } else {
            let text = hasAnyTrackers ? "Ничего не найдено" : "Что будем отслеживать?"
            setEmptyStateText(text)
            emptyStateView.isHidden = false
        }
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
    
    private func updateFilterButtonAppearance() {
        switch currentFilter {
        case .all, .today:
            filterButton.setTitleColor(.white, for: .normal)
        default:
            filterButton.setTitleColor(.systemRed, for: .normal)
        }
    }
    
    private func applyFilter() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        let currentWeekDay = WeekDay.allCases[adjustedWeekday - 1]

        let completedIds = completedTrackers
            .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
            .map { $0.trackerId }

        filteredCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let scheduled = tracker.schedule.contains(currentWeekDay)
                switch currentFilter {
                case .all, .today:
                    return scheduled
                case .completed:
                    return scheduled && completedIds.contains(tracker.id)
                case .notCompleted:
                    return scheduled && !completedIds.contains(tracker.id)
                }
            }
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }

        trackersCollectionView.reloadData()
        updateEmptyStateVisibility()
    }
}

extension TrackersViewController: FilterSelectionDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        if filter == .today {
            let today = Date()
            currentDate = today
            datePicker.setDate(today, animated: true)
        }
        currentFilter = filter
        UserDefaults.standard.set(filter.rawValue, forKey: "selectedFilter")
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
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 9
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148) 
    }
}

extension TrackersViewController: NewEventViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, in categoryTitle: String) {
        refreshData()
    }
}
