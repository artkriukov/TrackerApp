//
//  NewHabitViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 27.05.2025.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
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
}

private extension NewHabitViewController {
    func setupViews() {
        view.backgroundColor = UIConstants.MainColors.backgroundColor
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
