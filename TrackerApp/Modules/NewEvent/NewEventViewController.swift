//
//  NewEventViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

enum NewEventMode {
    case newHabbit
    case irregularEvent
}

final class NewEventViewController: UIViewController {
    
    private let mode: NewEventMode
    private let maxCharLimit = 1
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
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var errorLabel: UILabel = {
        let element = UILabel()
        element.text = "Ограничение \(maxCharLimit) символ"
        element.textColor = UIConstants.MainColors.redColor
        element.font = .systemFont(ofSize: 17)
        element.isHidden = true
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
        element.addAction(
            UIAction { _ in
                self.categoryButtonTapped()
            }, for: .touchUpInside
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
        element.addAction(
            UIAction { _ in
                self.scheduleButtonTapped()
            }, for: .touchUpInside
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
        let element = FactoryUI.shared.makeButton(
            title: "Отменить",
            backgroundColor: .clear,
            textColor: UIConstants.MainColors.redColor,
            borderColor: UIConstants.MainColors.redColor
        )
        element.addAction(
            UIAction { _ in
                self.cancelButtonTapped()
            }, for: .touchUpInside
        )
        return element
    }()
    
    
    private lazy var createButton = FactoryUI.shared.makeButton(
        title: "Создать",
        backgroundColor: UIConstants.MainColors.grayColor,
        textColor: .white
    )
    
    // MARK: - Init
    init(mode: NewEventMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        
        checkMode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func checkMode() {
        switch mode {
        case .newHabbit:
            title = "Новая привычка"
        case .irregularEvent:
            title = "Новое нерегулярное событие"
            scheduleButton.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func categoryButtonTapped() {
        let emptyCategoryVC = EmptyCategoryViewController()
        let navController = UINavigationController(rootViewController: emptyCategoryVC)
        present(navController, animated: true)
    }
    
    private func scheduleButtonTapped() {
        let tackerOptionsVC = TrackerOptionsViewController(mode: .schedule)
        let navController = UINavigationController(rootViewController: tackerOptionsVC)
        present(navController, animated: true)
    }
    
    private func updateErrorLabel(for text: String) {
        if text.count > maxCharLimit {
            UIView.animate(withDuration: 0.3) {
                self.errorLabel.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.errorLabel.isHidden = true
            }
        }
    }
}

private extension NewEventViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        
        view.addSubview(trackerTitleTextField)
        view.addSubview(errorLabel)
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
            
            errorLabel.topAnchor.constraint(equalTo: trackerTitleTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            topActionView.topAnchor
                .constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
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

extension NewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let stringRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            updateErrorLabel(for: updatedText)
        }
        return true
    }
}
