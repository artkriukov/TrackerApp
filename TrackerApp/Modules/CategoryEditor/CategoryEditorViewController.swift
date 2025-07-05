//
//  CategoryEditorViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit
import CoreData

enum CategoryEditorMode {
    case create
    case edit
}

final class CategoryEditorViewController: UIViewController {
    // MARK: - Private Properties
    private let mode: CategoryEditorMode
    private let tracker: Tracker?
    private var editingCategory: TrackerCategoryCoreData?
    var onCategoryCreated: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var textField: TextField = {
        let config = TextField.Configuration(
            placeholder: "Введите название категории",
            backgroundColor: Asset.MainColors.secondaryBackgroundColor
        )
        
        let element = TextField(configuration: config)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var doneButton = FactoryUI.shared.makeButton(
        title: "Готово",
        backgroundColor: Asset.MainColors.buttonColor,
        textColor: Asset.MainColors.secondaryTextColor
    )
    
    // MARK: - Init
    init(tracker: Tracker?, mode: CategoryEditorMode) {
        self.tracker = tracker
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
        setupHideKeyboardOnTap()
    }
    
    private func doneButtonTapped() {
        guard let name = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            return
        }

        switch mode {
        case .create:
            do {
                try TrackerCategoryStore.shared.addCategory(name)
                onCategoryCreated?()
            } catch {
                print("Error")
            }
            dismiss(animated: true)
        case .edit:
            dismiss(animated: true)
        }
    }
    

}

private extension CategoryEditorViewController {
    func setupViews() {
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        view.addSubview(textField)
        view.addSubview(doneButton)
        doneButton.addAction(UIAction { _ in
            self.doneButtonTapped()
        }, for: .touchUpInside)
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

extension CategoryEditorViewController {
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
