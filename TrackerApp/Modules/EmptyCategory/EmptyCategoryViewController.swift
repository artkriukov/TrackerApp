//
//  EmptyCategoryViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class EmptyCategoryViewController: UIViewController {

    // MARK: - UI
    private lazy var emptyStateView: UIStackView = {
        guard let image = UIImage(named: UIConstants.Images.trackersEmptyImage) else {
            return UIStackView()
        }
        let element = FactoryUI.shared.makeEmptyStateView(
            image: image,
            text: "Привычки и события можно объединить по смыслу"
        )
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var doneButton: UIButton = {
        let element = FactoryUI.shared.makeButton(
            title: "Добавить категорию",
            backgroundColor: UIConstants.MainColors.buttonColor,
            textColor: UIConstants.MainColors.secondaryTextColor
        )
        element.addTarget(
                self,
                action: #selector(doneButtonTapped),
                for: .touchUpInside
            )
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
    
    // MARK: - Private Properties
    
    @objc private func doneButtonTapped() {
        let categoryEditorVC = CategoryEditorViewController(mode: .create)
        let navController = UINavigationController(rootViewController: categoryEditorVC)
        present(navController, animated: true)
    }
}

private extension EmptyCategoryViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        
        view.addSubview(emptyStateView)
        view.addSubview(doneButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            doneButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            doneButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor,constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupNavigation() {
        title = "Категория"
    }
}
