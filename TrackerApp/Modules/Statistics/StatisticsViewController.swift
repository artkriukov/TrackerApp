//
//  StatisticsViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    private lazy var statsCell = StatisticsCellView()
    private lazy var emptyStateView: UIStackView = {
        guard let image = UIImage(named: Asset.Images.statsEmptyImage) else {
            return UIStackView()
        }
        let stackView = FactoryUI.shared.makeEmptyStateView(
            image: image,
            text: "Анализировать пока нечего"
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        setupViews()
        setupConstraints()
        updateStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }

    private func updateStatistics() {
        let count = TrackerRecordStore.shared.fetchAllRecords().count
        if count == 0 {
            emptyStateView.isHidden = false
            statsCell.isHidden = true
        } else {
            statsCell.configure(count: count)
            emptyStateView.isHidden = true
            statsCell.isHidden = false
        }
    }

    private func setupViews() {
        view.addSubview(statsCell)
        view.addSubview(emptyStateView)
        emptyStateView.isHidden = true
    }

    private func setupConstraints() {
        statsCell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsCell.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsCell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            statsCell.heightAnchor.constraint(equalToConstant: 90),
            statsCell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsCell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
