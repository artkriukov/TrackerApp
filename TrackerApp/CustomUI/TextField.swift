//
//  TextField.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class TextField: UITextField {
    
    private let textField = UITextField()
    
    init(configuration: Configuration) {
        super.init(frame: .zero)
        
        setup(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(configuration: Configuration) {
        addSubview(textField)
        
        placeholder = configuration.placeholder
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = 16
        font = .systemFont(ofSize: 17, weight: .regular)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}

extension TextField {
    struct Configuration {
        let placeholder: String
        let backgroundColor: UIColor?
    }
}
