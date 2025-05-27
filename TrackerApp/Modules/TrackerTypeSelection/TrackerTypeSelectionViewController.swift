//
//  TrackerTypeSelectionViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 25.05.2025.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    
    // MARK: - UI
    private lazy var buttonsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var habitButton: UIButton = {
        let habitButton = FactoryUI.shared.makeButton(
            title: "Привычка",
            backgroundColor: UIConstants.MainColors.buttonColor,
            textColor: UIConstants.MainColors.secondaryTextColor
        )
        habitButton.addTarget(
                self,
                action: #selector(habitButtonTapped),
                for: .touchUpInside
            )
        return habitButton
    }()
    
    
    private lazy var irregularEventButton = FactoryUI.shared.makeButton(
        title: "Нерегулярное событие",
        backgroundColor: UIConstants.MainColors.buttonColor,
        textColor: UIConstants.MainColors.secondaryTextColor
    )
    
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
    
    @objc private func habitButtonTapped() {
        let newHabbitVC = NewHabitViewController()
        let navController = UINavigationController(rootViewController: newHabbitVC)
        present(navController, animated: true)
    }
}

private extension TrackerTypeSelectionViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(habitButton)
        buttonsStackView.addArrangedSubview(irregularEventButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
