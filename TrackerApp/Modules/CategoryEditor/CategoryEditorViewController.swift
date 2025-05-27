//
//  CategoryEditorViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

enum CategoryEditorMode {
    case create
    case edit
}

final class CategoryEditorViewController: UIViewController {
    // MARK: - Private Properties
    private let mode: CategoryEditorMode
    
    // MARK: - UI
    
    private lazy var textField: TextField = {
        let config = TextField.Configuration(
            placeholder: "Введите название категории",
            backgroundColor: UIConstants.MainColors.secondaryBackgroundColor
        )
        
        let element = TextField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var doneButton = FactoryUI.shared.makeButton(
        title: "Готово",
        backgroundColor: UIConstants.MainColors.buttonColor,
        textColor: UIConstants.MainColors.secondaryTextColor
    )
    
    // MARK: - Init
    init(mode: CategoryEditorMode) {
        self.mode = mode
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
        applyModeConfiguration()
    }
}

private extension CategoryEditorViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.mainBackgroundColor
        view.addSubview(textField)
        view.addSubview(doneButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            textField.trailingAnchor
                .constraint(equalTo: view.trailingAnchor,constant: -16),
            
            doneButton.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            doneButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor,constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func applyModeConfiguration() {
        switch mode {
        case .create:
            title = "Новая категория"
        case .edit:
            title = "Редактирование категории"
        }
    }
}
