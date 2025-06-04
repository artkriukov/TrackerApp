//
//  IconTextButton.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class IconTextButton: UIControl {
    private let textLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private var configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(configuration: Configuration) {
        self.configuration = configuration
        textLabel.text = configuration.textLabel
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.isHidden = configuration.subtitle == nil
        imageView.image = configuration.image
    }
    
    private func setup() {
        addSubview(textLabel)
        addSubview(subtitleLabel)
        addSubview(imageView)
        
        textLabel.text = configuration.textLabel
        textLabel.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel.textColor = UIConstants.MainColors.mainTextColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIConstants.MainColors.grayColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.isHidden = configuration.subtitle == nil
        
        imageView.image = configuration.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIConstants.MainColors.redColor
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 7),
            imageView.heightAnchor.constraint(equalToConstant: 12),
            
            heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
    }
}

extension IconTextButton {
    struct Configuration {
        let textLabel: String
        let subtitle: String?
        let image: UIImage?
        let backgroundColor: UIColor?
        
        init(textLabel: String, subtitle: String? = nil, image: UIImage?, backgroundColor: UIColor?) {
            self.textLabel = textLabel
            self.subtitle = subtitle
            self.image = image
            self.backgroundColor = backgroundColor
        }
    }
}
