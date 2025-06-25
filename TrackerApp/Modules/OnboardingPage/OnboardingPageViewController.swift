//
//  OnboardingPageViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 23.06.2025.
//

import UIKit

struct OnboardingPage {
    let title: String
    let imageName: String
}

final class OnboardingPageViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 32, weight: .bold)
        element.textAlignment = .center
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    
    let page: OnboardingPage
    var currentPage: OnboardingPage { return page }
    
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWith(page: page)
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        imageView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                         constant: -300),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureWith(page: OnboardingPage) {
        imageView.image = UIImage(named: page.imageName)
        titleLabel.text = page.title
    }
}
