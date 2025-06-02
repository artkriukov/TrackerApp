//
//  NewHabitViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var contentView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var trackerTitleTextField: TextField = {
        let config = TextField.Configuration(
            placeholder: "Введите название трекера",
            backgroundColor: UIConstants.MainColors.secondaryBackgroundColor
        )
        
        let element = TextField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var topActionView: UIView = {
        let element = UIView()
        element.backgroundColor = UIConstants.MainColors.secondaryBackgroundColor
        element.layer.cornerRadius = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var topActionStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 25
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var categoryButton: IconTextButton = {
        let config = IconTextButton.Configuration(
            textLabel: "Категория",
            image: UIConstants.Icons.chevronRight,
            backgroundColor: .clear
        )
        let element = IconTextButton(configuration: config)
        element.addTarget(
                self,
                action: #selector(categoryButtonTapped),
                for: .touchUpInside
            )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var scheduleButton: IconTextButton = {
        let config = IconTextButton.Configuration(
            textLabel: "Расписание",
            image: UIConstants.Icons.chevronRight,
            backgroundColor: .clear
        )
        let element = IconTextButton(configuration: config)
        element.addTarget(
                self,
                action: #selector(scheduleButtonTapped),
                for: .touchUpInside
            )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var separatorView: UIView = {
        let element = UIView()
        element.backgroundColor = UIConstants.MainColors.separatorColor
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bottomActionStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.distribution = .fillEqually
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = FactoryUI.shared.makeButton(
            title: "Отменить",
            backgroundColor: .clear,
            textColor: UIConstants.MainColors.redColor,
            borderColor: UIConstants.MainColors.redColor
        )
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
        return cancelButton
    }()
    
    
    private lazy var createButton = FactoryUI.shared.makeButton(
        title: "Создать",
        backgroundColor: UIConstants.MainColors.grayColor,
        textColor: .white
    )
    
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "Новая привычка"
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func categoryButtonTapped() {
        let emptyCategoryVC = EmptyCategoryViewController()
        let navController = UINavigationController(rootViewController: emptyCategoryVC)
        present(navController, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        let tackerOptionsVC = TrackerOptionsViewController(mode: .schedule)
        let navController = UINavigationController(rootViewController: tackerOptionsVC)
        present(navController, animated: true)
    }
}

private extension NewHabitViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        
        view.addSubview(trackerTitleTextField)
        
        view.addSubview(topActionView)
        topActionView.addSubview(topActionStackView)
        
        topActionStackView.addArrangedSubview(categoryButton)
        topActionStackView.addArrangedSubview(separatorView)
        topActionStackView.addArrangedSubview(scheduleButton)
        
        view.addSubview(bottomActionStackView)
        bottomActionStackView.addArrangedSubview(cancelButton)
        bottomActionStackView.addArrangedSubview(createButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            trackerTitleTextField.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerTitleTextField.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerTitleTextField.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            topActionView.topAnchor
                .constraint(equalTo: trackerTitleTextField.bottomAnchor, constant: 24),
            topActionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topActionView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -20),
            
            topActionStackView.topAnchor
                .constraint(equalTo: topActionView.topAnchor, constant: 26),
            topActionStackView.leadingAnchor
                .constraint(equalTo: topActionView.leadingAnchor, constant: 16),
            topActionStackView.trailingAnchor
                .constraint(equalTo: topActionView.trailingAnchor, constant: -16),
            topActionStackView.bottomAnchor
                .constraint(equalTo: topActionView.bottomAnchor, constant: -26),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomActionStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bottomActionStackView.trailingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            bottomActionStackView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
