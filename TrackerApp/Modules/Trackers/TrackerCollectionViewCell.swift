//
//  TrackerCollectionViewCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 26.05.2025.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    
    private lazy var trackerCardStackView: UIStackView = {
        let element = UIStackView()
        element.backgroundColor = UIConstants.SelectionColors.colorSelection5
        element.layer.cornerRadius = 16
        element.spacing = 8
        element.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        element.isLayoutMarginsRelativeArrangement = true
        element.axis = .vertical
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var headerStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fill
        element.alignment = .top
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var emojiContainerView: UIView = {
        let element = UIView()
        element.backgroundColor = UIColor(hexString: "#B3FFFFFF")
        element.layer.cornerRadius = 12
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var emojiLabel: UILabel = {
        let element = UILabel()
        element.text = "😻"
        element.font = .systemFont(ofSize: 16)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var trackerLabel: UILabel = {
        let element = UILabel()
        element.text = "Кошка заслонила камеру на созвоне"
        element.numberOfLines = 2
        element.font = .systemFont(ofSize: 12, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionStackView: UIStackView = {
        let element = UIStackView()
        element.backgroundColor = UIConstants.MainColors.backgroundColor
        element.axis = .horizontal
        element.alignment = .center
        element.distribution = .fill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var trackedDaysCount: UILabel = {
        let element = UILabel()
        element.text = "5 дней"
        element.font = .systemFont(ofSize: 12, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var completeButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("+", for: .normal)
        element.backgroundColor = UIConstants.SelectionColors.colorSelection5
        element.layer.cornerRadius = 17
        element.tintColor = UIColor.white
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with category: TrackerCategory) {
        
    }
}

private extension TrackerCollectionViewCell {
    func setupViews() {
        contentView.addSubview(trackerCardStackView)
        
        trackerCardStackView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(emojiContainerView)
        headerStackView.addArrangedSubview(UIView())
        
        trackerCardStackView.addArrangedSubview(trackerLabel)
        emojiContainerView.addSubview(emojiLabel)
        
        contentView.addSubview(actionStackView)
        actionStackView.addArrangedSubview(trackedDaysCount)
        actionStackView.addArrangedSubview(completeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerCardStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCardStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardStackView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiContainerView.widthAnchor.constraint(equalToConstant: 24),
            emojiContainerView.heightAnchor.constraint(equalTo: emojiContainerView.widthAnchor),
            emojiContainerView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor),
            emojiContainerView.topAnchor.constraint(equalTo: headerStackView.topAnchor),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainerView.centerYAnchor),
            
            trackerLabel.leadingAnchor.constraint(equalTo: trackerCardStackView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: trackerCardStackView.trailingAnchor, constant: -12),
            trackerLabel.bottomAnchor.constraint(equalTo: trackerCardStackView.bottomAnchor, constant: -12),
            
            actionStackView.topAnchor.constraint(equalTo: trackerCardStackView.bottomAnchor),
            actionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            actionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
}
