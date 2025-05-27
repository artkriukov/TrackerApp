//
//  ButtonPairStackView.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 25.05.2025.
//

import UIKit

final class ButtonPairStackView: UIStackView {
    private let stackView = UIStackView()
    private var primaryButton = UIButton()
    private var secondaryButton = UIButton()
    
    private var primaryButtonAction: (() -> Void)?
    init(config: Configuration) {
        super.init(frame: .zero)
        
        setup(config: config)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(config: Configuration) {
        self.axis = config.axis
        self.spacing = config.spacing
        self.primaryButtonAction = config.primaryButtonAction
        
        primaryButton = FactoryUI.shared.makeButton(
            title: config.primaryButtonTitle,
            backgroundColor: config.backgroundColor,
            textColor: .white
        )
        
        primaryButton
            .addTarget(
                self,
                action: #selector(handlePrimaryButtonTap),
                for: .touchUpInside
            )
        
        secondaryButton = FactoryUI.shared.makeButton(
            title: config.secondaryButtonTitle,
            backgroundColor: config.backgroundColor,
            textColor: .white
        )
        
        [primaryButton, secondaryButton].forEach {
            self.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            primaryButton.heightAnchor.constraint(equalToConstant: config.heightButton),
            secondaryButton.heightAnchor.constraint(equalToConstant: config.heightButton),
        ])
    }
    
    @objc private func handlePrimaryButtonTap() {
        primaryButtonAction?()
    }
}

extension ButtonPairStackView {
    struct Configuration {
        let primaryButtonTitle: String
        let secondaryButtonTitle: String
        let backgroundColor: UIColor
        let heightButton: CGFloat
        let axis: NSLayoutConstraint.Axis
        let spacing: CGFloat
        
        let primaryButtonAction: () -> Void
    }
}
