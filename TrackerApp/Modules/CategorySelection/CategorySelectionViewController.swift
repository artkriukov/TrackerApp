//
//  CategorySelectionViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 24.06.2025.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CategorySelectionViewModel
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.separatorStyle = .none
        element.rowHeight = UITableView.automaticDimension
        element.estimatedRowHeight = 75
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actionButton: UIButton = {
        let element = FactoryUI.shared.makeButton(
            title: "Добавить категорию",
            backgroundColor: Asset.MainColors.buttonColor,
            textColor: Asset.MainColors.secondaryTextColor
        )
        element.addAction(
            UIAction { [weak self] _ in
                self?.addCategoryTapped()
            }, for: .touchUpInside
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Init
    init(viewModel: CategorySelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
        viewModel.loadCategories()
        
        title = "Категория"
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CollectionViewCellIdentifiers.categoryTableViewCell
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.constraints.first(where: { $0.firstAttribute == .height })?.constant = tableView.contentSize.height
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        viewModel.categoriesDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func addCategoryTapped() {
        let categoryEditorVC = CategoryEditorViewController(mode: .create)
        categoryEditorVC.onCategoryCreated = { [weak self] in
            // После создания новой категории обновляем список
            self?.viewModel.loadCategories()
            // Закрываем редактор
            self?.dismiss(animated: true)
        }
        let navController = UINavigationController(rootViewController: categoryEditorVC)
        present(navController, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewCellIdentifiers.categoryTableViewCell,
            for: indexPath
        ) as? CategoryTableViewCell else { return UITableViewCell() }
        
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.isCategorySelected(at: indexPath.row)
        cell.configure(with: category.name ?? "Без названия", isSelected: isSelected)
        cell.setSeparatorHidden(indexPath.row == viewModel.categories.count - 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let cornerRadius: CGFloat = 16
        var corners: UIRectCorner = []
        
        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }
        
        let path = UIBezierPath(
            roundedRect: cell.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cell.layer.mask = mask
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
}

// MARK: - Layout
extension CategorySelectionViewController {
    private func setupViews() {
        view.backgroundColor = Asset.MainColors.mainBackgroundColor
        view.addSubview(tableView)
        view.addSubview(actionButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 40),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
