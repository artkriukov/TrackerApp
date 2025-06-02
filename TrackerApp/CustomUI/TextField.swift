//
//  TextField.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class TextField: UITextField {
    
    private let label = UILabel()
    
    private let maxCharLimit = 1
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        
        addSubview(label)
        
        configureTextField(configuration: configuration)
        configureLabel()
        setupConstraints()
        
        addAction(
            UIAction { _ in
                self.textFieldDidChange()
            }, for: .editingChanged
        )
    }
    
    private func configureTextField(configuration: Configuration) {
        placeholder = configuration.placeholder
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = 16
        font = .systemFont(ofSize: 17, weight: .regular)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    private func configureLabel() {
        label.text = "Ограничение \(maxCharLimit) символов"
        label.textColor = UIConstants.MainColors.redColor
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // TextField
            heightAnchor.constraint(equalToConstant: 75),
            
            label.topAnchor
                .constraint(equalTo: bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func validateCharCountAndWarn() {
        guard let textField = self.text else { return }
        if textField.count >= maxCharLimit {
            UIView.animate(withDuration: 0.3) {
                self.label.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.label.isHidden = true
            }
        }
    }
    
    private func textFieldDidChange() {
        validateCharCountAndWarn()
    }
}

extension TextField {
    struct Configuration {
        let placeholder: String
        let backgroundColor: UIColor?
    }
}
