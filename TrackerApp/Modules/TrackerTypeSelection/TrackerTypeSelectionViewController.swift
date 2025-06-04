//
//  TrackerTypeSelectionViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 25.05.2025.
//

import UIKit

final class TrackerTypeSelectionViewController: UIViewController {
    
    private weak var trackersViewController: TrackersViewController?
    
    // MARK: - UI
    private lazy var buttonsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var habitButton: UIButton = {
        let element = FactoryUI.shared.makeButton(
            title: "Привычка",
            backgroundColor: Asset.MainColors.buttonColor,
            textColor: Asset.MainColors.secondaryTextColor
        )
        
        element.addAction(
            UIAction {_ in
                self.habitButtonTapped()
            }, for: .touchUpInside
        )
        return element
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let element = FactoryUI.shared.makeButton(
            title: "Нерегулярное событие",
            backgroundColor: Asset.MainColors.buttonColor,
            textColor: Asset.MainColors.secondaryTextColor
        )
        
        element.addAction(
            UIAction {_ in
                self.irregularEventButtonTapped()
            }, for: .touchUpInside
        )
        return element
    }()
    
    // MARK: - Init
    init(trackersViewController: TrackersViewController) {
        self.trackersViewController = trackersViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func habitButtonTapped() {
        let newEventVC = NewEventViewController(mode: .newHabbit)
        newEventVC.delegate = trackersViewController
        let navController = UINavigationController(rootViewController: newEventVC)
        present(navController, animated: true)
    }
    
    private func irregularEventButtonTapped() {
        let newEventVC = NewEventViewController(mode: .irregularEvent)
        newEventVC.delegate = trackersViewController
        let navController = UINavigationController(rootViewController: newEventVC)
        present(navController, animated: true)
    }
}

private extension TrackerTypeSelectionViewController {
    func setupViews() {
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        
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
