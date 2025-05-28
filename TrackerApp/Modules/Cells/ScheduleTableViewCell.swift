//
//  ScheduleCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 28.05.2025.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {

    // MARK: - UI
    
    private lazy var stackView = FactoryUI.shared.makeTrackerOptionsStackView()
    private lazy var customTextLabel = FactoryUI.shared.makeTextLabel()
    
    private lazy var switcher: UISwitch = {
        let element = UISwitch()
        element.onTintColor = UIConstants.MainColors.blueColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
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
    
    func configureCell() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
}

private extension ScheduleTableViewCell {
    func setupViews() {
        backgroundColor = UIConstants.MainColors.secondaryBackgroundColor
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(customTextLabel)
        stackView.addArrangedSubview(switcher)
        
        customTextLabel.text = "hello"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27),
        ])
    }
}
