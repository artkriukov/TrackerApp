//
//  NewEventViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit
import CoreData

enum NewEventMode {
    case newHabbit
    case irregularEvent
}

protocol NewEventViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, in categoryTitle: String)
}

final class NewEventViewController: UIViewController {
    
    private let mode: NewEventMode
    private let maxCharLimit = 38
    
    private var topActionViewTopConstraint: NSLayoutConstraint?
    weak var delegate: NewEventViewControllerDelegate?
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    private var selectedDays: [WeekDay] = [] {
        didSet {
            updateScheduleButton()
        }
    }
    
    // MARK: - Data Source
    private enum Emoji {
        static let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    }
    
    private enum Colors {
        static let colors: [UIColor] = [
            UIColor(hexString: "FD4C49"),
            UIColor(hexString: "FF881E"),
            UIColor(hexString: "007BFA"),
            UIColor(hexString: "6E44FE"),
            UIColor(hexString: "33CF69"),
            UIColor(hexString: "E66DD4"),
            UIColor(hexString: "F9D4D4"),
            UIColor(hexString: "34A7FE"),
            UIColor(hexString: "46E69D"),
            UIColor(hexString: "35347C"),
            UIColor(hexString: "FF674D"),
            UIColor(hexString: "FF99CC"),
            UIColor(hexString: "F6C48B"),
            UIColor(hexString: "7994F5"),
            UIColor(hexString: "832CF1"),
            UIColor(hexString: "AD56DA"),
            UIColor(hexString: "8D72E6"),
            UIColor(hexString: "2FD058")
        ]
    }
    
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.keyboardDismissMode = .onDrag
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
            backgroundColor: Asset.MainColors.secondaryBackgroundColor
        )
        
        let element = TextField(configuration: config)
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var errorLabel: UILabel = {
        let element = UILabel()
        element.text = "Ограничение \(maxCharLimit) символ"
        element.textColor = Asset.MainColors.redColor
        element.font = .systemFont(ofSize: 17)
        element.isHidden = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var topActionView: UIView = {
        let element = UIView()
        element.backgroundColor = Asset.MainColors.secondaryBackgroundColor
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
            image: Asset.Icons.chevronRight,
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
            subtitle: nil,
            image: Asset.Icons.chevronRight,
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
        element.backgroundColor = Asset.MainColors.separatorColor
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
            textColor: Asset.MainColors.redColor,
            borderColor: Asset.MainColors.redColor
        )
        element.addAction(
            UIAction { _ in
                self.cancelButtonTapped()
            }, for: .touchUpInside
        )
        return element
    }()
    
    
    private lazy var createButton: UIButton = {
        let button = FactoryUI.shared.makeButton(title: "Создать", backgroundColor: Asset.MainColors.buttonColor, textColor: Asset.MainColors.secondaryTextColor)
        button.addAction(UIAction { [weak self] _ in
            self?.createTracker()
        }, for: .touchUpInside)
        button.backgroundColor = Asset.MainColors.grayColor
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
        element.delegate = self
        element.dataSource = self
        element.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        element.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        element.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        element.allowsMultipleSelection = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
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
        setupHideKeyboardOnTap()
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
        let categories = TrackerCategoryStore.shared.fetchAllCategories()
        
        if categories.isEmpty {
            // Если категорий нет, открываем редактор категорий
            let categoryEditorVC = CategoryEditorViewController(mode: .create)
            categoryEditorVC.onCategoryCreated = { [weak self] in
                self?.categoryButtonTapped()
            }
            let navController = UINavigationController(rootViewController: categoryEditorVC)
            present(navController, animated: true)
        } else {
           
            let viewModel = CategorySelectionViewModel()
            viewModel.onCategorySelected = { [weak self] categoryName in
                let newConfig = IconTextButton.Configuration(
                    textLabel: "Категория",
                    subtitle: categoryName,
                    image: Asset.Icons.chevronRight,
                    backgroundColor: .clear
                )
                self?.categoryButton.update(configuration: newConfig)
                self?.updateCreateButtonState()
            }
            
            let categorySelectionVC = CategorySelectionViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: categorySelectionVC)
            present(navController, animated: true)
        }
    }

    private func scheduleButtonTapped() {
        let trackerOptionsVC = ScheduleViewController()
        trackerOptionsVC.selectedDays = selectedDays
        trackerOptionsVC.onDaysSelected = { [weak self] days in
            self?.selectedDays = days
            self?.updateScheduleButton()
        }
        let navController = UINavigationController(rootViewController: trackerOptionsVC)
        present(navController, animated: true)
    }
    
    private func updateErrorLabel(for text: String) {
        if text.count > maxCharLimit {
            UIView.animate(withDuration: 0.3) {
                self.errorLabel.isHidden = false
                self.topActionViewTopConstraint?.constant = 62
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.errorLabel.isHidden = true
                self.topActionViewTopConstraint?.constant = 24
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func createTracker() {
        guard let name = trackerTitleTextField.text, !name.isEmpty,
              let emoji = selectedEmoji,
              let color = selectedColor,
              let categoryName = categoryButton.configuration.subtitle ?? TrackerCategoryStore.shared.fetchAllCategories().first?.name else {
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: mode == .newHabbit ? Set(selectedDays) : [],
            categoryName: categoryName,
            createdAt: Date(),
            isPinned: false
        )
        
        TrackerStore.shared.addTracker(tracker, categoryTitle: categoryName, createdAt: Date())
        
        delegate?.didCreateTracker(tracker, in: categoryName)
        
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    private func updateScheduleButton() {
        let newConfig = IconTextButton.Configuration(
            textLabel: "Расписание",
            subtitle: selectedDays.isEmpty ? nil : selectedDays.count == WeekDay.allCases.count ?
            "Каждый день" :
                selectedDays.map { $0.shortName }.joined(separator: ", "),
            image: Asset.Icons.chevronRight,
            backgroundColor: .clear
        )
        scheduleButton.update(configuration: newConfig)
    }
    
    private func updateCreateButtonState() {
        let isTitleValid = !(trackerTitleTextField.text?.isEmpty ?? true) && errorLabel.isHidden
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        let isScheduleValid = mode == .irregularEvent || !selectedDays.isEmpty
        let isCategorySelected = categoryButton.configuration.subtitle != nil
        
        let isEnabled = isTitleValid && isEmojiSelected && isColorSelected && isScheduleValid && isCategorySelected
        
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? Asset.MainColors.buttonColor : Asset.MainColors.grayColor
    }
}

private extension NewEventViewController {
    func setupViews() {
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(trackerTitleTextField)
        contentView.addSubview(errorLabel)
        contentView.addSubview(topActionView)
        topActionView.addSubview(topActionStackView)
        
        topActionStackView.addArrangedSubview(categoryButton)
        topActionStackView.addArrangedSubview(separatorView)
        topActionStackView.addArrangedSubview(scheduleButton)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(bottomActionStackView)
        
        bottomActionStackView.addArrangedSubview(cancelButton)
        bottomActionStackView.addArrangedSubview(createButton)
        
        topActionViewTopConstraint = topActionView.topAnchor.constraint(equalTo: trackerTitleTextField.bottomAnchor, constant: 24)
        topActionViewTopConstraint?.isActive = true
    }
    
    func setupConstraints() {
       
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            trackerTitleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            trackerTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerTitleTextField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: trackerTitleTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            topActionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topActionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            topActionStackView.topAnchor.constraint(equalTo: topActionView.topAnchor, constant: 26),
            topActionStackView.leadingAnchor.constraint(equalTo: topActionView.leadingAnchor, constant: 16),
            topActionStackView.trailingAnchor.constraint(equalTo: topActionView.trailingAnchor, constant: -16),
            topActionStackView.bottomAnchor.constraint(equalTo: topActionView.bottomAnchor, constant: -26),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            collectionView.topAnchor.constraint(equalTo: topActionView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            
            bottomActionStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            bottomActionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomActionStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bottomActionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bottomActionStackView.heightAnchor.constraint(equalToConstant: 60),
            
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

extension NewEventViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? Emoji.emojis.count : Colors.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 
        let cellWidth = (availableWidth - 9) / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.identifier,
                for: indexPath
            ) as? EmojiCell else {
                assertionFailure("Failed to dequeue EmojiCell")
                return UICollectionViewCell()
            }
            cell.configure(with: Emoji.emojis[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.identifier,
                for: indexPath
            ) as? ColorCell else {
                assertionFailure("Failed to dequeue ColorCell")
                return UICollectionViewCell()
            }
            cell.configure(with: Colors.colors[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.identifier,
            for: indexPath
        ) as? HeaderView else {
            assertionFailure("Не удалось создать HeaderView")
            return UICollectionReusableView()
        }
        
        let title = indexPath.section == 0 ? "Emoji" : "Цвет"
        header.configure(title: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            collectionView.indexPathsForSelectedItems?
                .filter { $0.section == 0 && $0 != indexPath }
                .forEach { collectionView.deselectItem(at: $0, animated: false) }
            
            selectedEmoji = Emoji.emojis[indexPath.row]
        } else {
            collectionView.indexPathsForSelectedItems?
                .filter { $0.section == 1 && $0 != indexPath }
                .forEach { collectionView.deselectItem(at: $0, animated: false) }
            
            selectedColor = Colors.colors[indexPath.row]
        }
        updateCreateButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension NewEventViewController {
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
