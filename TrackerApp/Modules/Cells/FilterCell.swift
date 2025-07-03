//
//  FilterCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 03.07.2025.
//

import UIKit

final class FilterCell: UITableViewCell {
    static let reuseIdentifier = "FilterCell"

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = Asset.MainColors.mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.MainColors.grayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.backgroundColor = Asset.MainColors.secondaryBackgroundColor
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 14),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 14),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    // MARK: - Public

    func configure(text: String, showCheckmark: Bool, isLast: Bool) {
        titleLabel.text = text
        checkmarkImageView.isHidden = !showCheckmark
        checkmarkImageView.image = showCheckmark ? Asset.Icons.checkmark : nil
        separatorView.isHidden = isLast
    }
}
