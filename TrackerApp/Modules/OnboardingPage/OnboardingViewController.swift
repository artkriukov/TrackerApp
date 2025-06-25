//
//  OnboardingViewController.swift
//  TrackerApp
//
//  Created by Artem Kriukov on 23.06.2025.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

final class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var onFinish: (() -> Void)?
    
    private var pageViewController: UIPageViewController?
    private let pageControl = UIPageControl()
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Отслеживайте только то, что хотите",
            imageName: Asset.OnboardingImage.blueBackgraundImage
        ),
        OnboardingPage(
            title: "Даже если это не литры воды и йога",
            imageName: Asset.OnboardingImage.redBackgraundImage
        )
    ]
    
    private lazy var skipButton: UIButton = {
        let button = FactoryUI.shared.makeButton(
            title: "Вот это технологии!",
            backgroundColor: Asset.MainColors.buttonColor,
            textColor: Asset.MainColors.secondaryTextColor
        )
        
        button.addAction(
            UIAction { [weak self] _ in
                self?.onFinish?()
            }, for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupUI()
        setupPageControl()
    }
    
    private func setupPageViewController() {
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        pvc.dataSource = self
        pvc.delegate = self
        
        if let firstViewController = viewControllerAtIndex(0) {
            pvc.setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
        
        addChild(pvc)
        if let pvcView = pvc.view {
            view.addSubview(pvcView)
        }
        pvc.didMove(toParent: self)
        pageViewController = pvc
    }
    
    private func setupUI() {
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
    }
    
    private func viewControllerAtIndex(_ index: Int) -> OnboardingPageViewController? {
        guard pages.indices.contains(index) else { return nil }
        return OnboardingPageViewController(page: pages[index])
    }
    
    private func indexOfViewController(_ viewController: OnboardingPageViewController) -> Int {
        return pages.firstIndex { $0.title == viewController.page.title } ?? NSNotFound
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageViewController else { return nil }
        let index = indexOfViewController(vc)
        guard index != NSNotFound, index > 0 else { return nil }
        return viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageViewController else { return nil }
        let index = indexOfViewController(vc)
        guard index != NSNotFound, index < pages.count - 1 else { return nil }
        return viewControllerAtIndex(index + 1)
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController,
                           didFinishAnimating finished: Bool,
                           previousViewControllers: [UIViewController],
                           transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController else {
            return
        }
        let index = indexOfViewController(currentVC)
        pageControl.currentPage = index
    }
}
