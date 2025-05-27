//
//  IconTextButton.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class IconTextButton: UIControl {
    
    private let textLabel = UILabel()
    private let imageView = UIImageView()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        addSubview(textLabel)
        addSubview(imageView)
        
        textLabel.text = configuration.textLabel
        textLabel.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel.textColor = UIConstants.MainColors.mainTextColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = configuration.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIConstants.MainColors.redColor
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 7),
            imageView.heightAnchor.constraint(equalToConstant: 12),
            
            heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

extension IconTextButton {
    struct Configuration {
        let textLabel: String
        let image: UIImage?
        let backgroundColor: UIColor?
    }
}
