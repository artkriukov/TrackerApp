//
//  FactoryUI.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 18.05.2025.
//

import UIKit

final class FactoryUI {
    static let shared = FactoryUI()
    private init() {}
    
    func makeEmptyStateView(
        image: UIImage,
        text: String,
        spacing: CGFloat = 8,
        imageSize: CGSize = CGSize(width: 80, height: 80)
    ) -> UIStackView {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = spacing
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = imageSize

        
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = text
        label.numberOfLines = 2
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    func makeButton(
        title: String,
        backgroundColor: UIColor,
        textColor: UIColor,
        borderColor: UIColor? = nil,
        cornerRadius: CGFloat = 16,
        tamic: Bool = false
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.tintColor = textColor
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        if let borderColor {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1
        }
        button.translatesAutoresizingMaskIntoConstraints = tamic
        return button
    }
    
    func makeTextLabel() -> UILabel{
        let label = UILabel()
        label.textColor = Asset.MainColors.mainTextColor
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeTrackerOptionsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
