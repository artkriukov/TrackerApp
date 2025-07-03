//
//  StatisticsCellView.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import UIKit

final class StatisticsCellView: GradientBorderView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        borderWidth = 1
        cornerRadius = 16
        gradientColors = [
            UIColor(hexString: "FD4C49"),
            UIColor(hexString: "46E69D"),
            UIColor(hexString: "007BFA")
        ]
        backgroundColor = Asset.MainColors.mainBackgroundColor

        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        valueLabel.textAlignment = .left

        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .left
        titleLabel.text = "Трекеров завершено"

        addSubview(valueLabel)
        addSubview(titleLabel)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(count: Int) {
        valueLabel.text = "\(count)"
    }
}
