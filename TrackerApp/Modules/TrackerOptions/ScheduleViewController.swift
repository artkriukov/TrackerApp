//
//  ScheduleViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 28.05.2025.
//

import UIKit
import CoreData

final class ScheduleViewController: UIViewController {
    // MARK: - Properties
    var selectedDays: [WeekDay] = []
    var onDaysSelected: (([WeekDay]) -> Void)?
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.separatorStyle = .none
        element.rowHeight = UITableView.automaticDimension
        element.estimatedRowHeight = 75
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionButton: UIButton = {
        let element = FactoryUI.shared.makeButton(
            title: "Готово",
            backgroundColor: Asset.MainColors.buttonColor,
            textColor: Asset.MainColors.secondaryTextColor
        )
        element.addAction(
            UIAction { [weak self] _ in
                self?.actionButtonTapped()
            }, for: .touchUpInside
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.constraints.first(where: { $0.firstAttribute == .height })?.constant = tableView.contentSize.height
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        title = "Расписание"
        tableView.register(
            ScheduleTableViewCell.self,
            forCellReuseIdentifier: CollectionViewCellIdentifiers.scheduleTableViewCell
        )
    }
    
    private func actionButtonTapped() {
        onDaysSelected?(selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewCellIdentifiers.scheduleTableViewCell,
            for: indexPath
        ) as? ScheduleTableViewCell else { return UITableViewCell() }
        
        let day = WeekDay.allCases[indexPath.row]
        let isSelected = selectedDays.contains(day)
        
        cell.selectionStyle = .none
        cell.configureCell(
            with: day,
            isSelected: isSelected,
            onSwitchChanged: { [weak self] day, isSelected in
                if isSelected {
                    self?.selectedDays.append(day)
                } else {
                    self?.selectedDays.removeAll { $0 == day }
                }
            }
        )
        
        let isLast = indexPath.row == WeekDay.allCases.count - 1
        let isOnly = WeekDay.allCases.count == 1
        cell.setSeparatorHidden(isLast || isOnly)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let cornerRadius: CGFloat = 16
        var corners: UIRectCorner = []
        
        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }
        
        let path = UIBezierPath(
            roundedRect: cell.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cell.layer.mask = mask
    }
}

// MARK: - Layout
extension ScheduleViewController {
    private func setupViews() {
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        view.addSubview(tableView)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 40),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
