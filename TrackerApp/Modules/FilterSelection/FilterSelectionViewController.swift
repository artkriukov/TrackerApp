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
        view.backgroundColor = .systemBackground
        title = "Фильтры"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
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
        let filter = filters[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filter.title

        // Галочка только для completed/notCompleted
        if (filter == .completed || filter == .notCompleted), filter == selectedFilter {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .systemBlue
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .label
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        delegate?.didSelectFilter(filter)
        dismiss(animated: true)
    }
}
