//
//  FilterSelectionViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import UIKit

protocol FilterSelectionDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FilterSelectionViewController: UIViewController {
    private let filters: [TrackerFilter] = [.all, .today, .completed, .notCompleted]
    private var selectedFilter: TrackerFilter
    weak var delegate: FilterSelectionDelegate?

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    init(selectedFilter: TrackerFilter) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        title = "Фильтры"

        setupTableView()
        setupConstraints()
    }

    private func setupTableView() {
        tableView.backgroundColor = Asset.MainColors.secondaryBackgroundColor
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension FilterSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        let filter = filters[indexPath.row]
        let showCheckmark = (filter == .completed || filter == .notCompleted) && filter == selectedFilter
        let isLast = indexPath.row == filters.count - 1
        cell.configure(text: filter.title, showCheckmark: showCheckmark, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        delegate?.didSelectFilter(filter)
        dismiss(animated: true)
    }
}
