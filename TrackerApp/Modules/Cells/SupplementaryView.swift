//
//  SupplementaryView.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 28.05.2025.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Домашний уют"
        element.font = .systemFont(ofSize: 19, weight: .bold)
        element.textColor = UIConstants.MainColors.mainTextColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
