//
//  TrackerCollectionViewCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 26.05.2025.
//

import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func completeTracker(id: String)
    func uncompleteTracker(id: String)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private var trackerIsDone = false
    private var tracker: Tracker?
    private var currentDate = Date()
    private var isCompletedToday = false
    
    var completionHandler: (() -> Void)?
    weak var delegate: TrackerCollectionViewCellDelegate?
    // MARK: - UI
    
    private lazy var trackerCardStackView: UIStackView = {
        let element = UIStackView()
        element.backgroundColor = Asset.SelectionColors.colorSelection5
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
        element.backgroundColor = UIColor(hexString: "#FFFFFF", alpha: 0.3)
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
        element.textColor = Asset.MainColors.secondaryTextColor
        element.font = .systemFont(ofSize: 12, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionStackView: UIStackView = {
        let element = UIStackView()
        element.backgroundColor = Asset.MainColors.mainBackgroundColor
        element.axis = .horizontal
        element.alignment = .center
        element.distribution = .fill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var trackedDaysCount: UILabel = {
        let element = UILabel()
        element.text = "5 дней"
        element.textColor = Asset.MainColors.mainTextColor
        element.font = .systemFont(ofSize: 12, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var completeButton: UIButton = {
        let element = UIButton(type: .system)
        element.backgroundColor = Asset.SelectionColors.colorSelection5
        element.layer.cornerRadius = 17
        element.tintColor = Asset.MainColors.secondaryTextColor
        element.addAction(
            UIAction { [weak self] _ in
                self?.completeButtonTapped()
            }, for: .touchUpInside)
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
    
    func configureCell(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        currentDate: Date
    ) {
        self.tracker = tracker
        self.currentDate = currentDate
        self.isCompletedToday = isCompletedToday
        
        trackerCardStackView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        trackerLabel.text = tracker.name
        completeButton.backgroundColor = tracker.color
        trackedDaysCount.text = String.localizedStringWithFormat(
            NSLocalizedString("%d days", comment: ""),
            completedDays
        )
        
        let image = isCompletedToday ?
        Asset.Icons.doneTrackerButton :
        Asset.Icons.plusButton
        let resizedImage = resizeImage(image, to: CGSize(width: 10, height: 10))
        completeButton.setImage(resizedImage, for: .normal)
        completeButton.layer.opacity = isCompletedToday ? 0.3 : 1
    }
    
    // MARK: - Private Methods
    private func completeButtonTapped() {
        guard let trackerId = tracker?.id else { return }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId.uuidString)
        } else {
            guard currentDate <= Date() else { return }
            delegate?.completeTracker(id: trackerId.uuidString)
        }
        
        resizedButton()
    }
    
    private func resizedButton() {
        if !trackerIsDone {
            let resizedDoneImage = resizeImage(Asset.Icons.doneTrackerButton, to: CGSize(width: 10, height: 10))
            completeButton.setImage(resizedDoneImage, for: .normal)
            completeButton.layer.opacity = 0.3
        } else {
            let resizedPlusImage = resizeImage(Asset.Icons.plusButton, to: CGSize(width: 10, height: 10))
            completeButton.setImage(resizedPlusImage, for: .normal)
            completeButton.layer.opacity = 1.0
        }
        trackerIsDone.toggle()
    }
    
    private func resizeImage(_ image: UIImage?, to size: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
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
            actionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            actionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
}
