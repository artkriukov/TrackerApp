//
//  TrackerTypeSelectionViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 25.05.2025.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var buttonsStackView: ButtonPairStackView = {
        let config = ButtonPairStackView.Configuration(
            primaryButtonTitle: "Привычка",
            secondaryButtonTitle: "Нерегулярное событие",
            backgroundColor: UIConstants.MainColors.buttonColor,
            heightButton: 60,
            axis: .vertical,
            spacing: 16
        )
        
        let element = ButtonPairStackView(config: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigation()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigation() {
        title = "Создание трекера"
    }
}

private extension TrackerTypeSelectionViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackground
        
        view.addSubview(buttonsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
