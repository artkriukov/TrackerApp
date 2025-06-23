//
//  ScheduleCell.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 28.05.2025.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {

    private var day: WeekDay?
    private var onSwitchChanged: ((WeekDay, Bool) -> Void)?
    
    // MARK: - UI
    
    private lazy var stackView = FactoryUI.shared.makeTrackerOptionsStackView()
    private lazy var customTextLabel = FactoryUI.shared.makeTextLabel()
    
    private lazy var switcher: UISwitch = {
        let element = UISwitch()
        element.onTintColor = Asset.MainColors.blueColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var separator: UIView = {
        let element = UIView()
        element.backgroundColor = Asset.MainColors.separatorColor
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customTextLabel.text = nil
    }
    
    func configureCell(with day: WeekDay, isSelected: Bool = false, onSwitchChanged: @escaping (WeekDay, Bool) -> Void) {
        self.day = day
        self.onSwitchChanged = onSwitchChanged
        customTextLabel.text = day.fullName
        switcher.isOn = isSelected
        
        switcher.addAction(
            UIAction { [weak self] _ in
                guard let self = self, let day = self.day else { return }
                self.onSwitchChanged?(day, self.switcher.isOn)
            },
            for: .valueChanged
        )
    }
    
    func setSeparatorHidden(_ hidden: Bool) {
        separator.isHidden = hidden
    }
}

private extension ScheduleTableViewCell {
    func setupViews() {
        backgroundColor = Asset.MainColors.secondaryBackgroundColor
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(customTextLabel)
        stackView.addArrangedSubview(switcher)
        contentView.addSubview(separator)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            stackView.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
