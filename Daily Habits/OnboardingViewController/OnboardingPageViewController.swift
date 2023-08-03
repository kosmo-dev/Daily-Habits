//
//  OnboardingPageViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 19.07.2023.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {

    let firstViewController = OnboardingViewController(image: UIImage(named: C.UIImages.onboardingFirst)!,
                                                       text: S.OnboardingViewController.firstViewControllerText)
    let secondViewController = OnboardingViewController(image: UIImage(named: C.UIImages.onboardingSecond)!,
                                                        text: S.OnboardingViewController.secondViewControllerText)

    lazy var pages: [UIViewController] = [firstViewController, secondViewController]

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    let button = PrimaryButton(title: S.OnboardingViewController.button, action: #selector(buttonTapped), type: .primary)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        dataSource = self
        delegate = self

        configureView()
    }

    private func configureView() {
        view.addSubview(pageControl)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),

            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        ])
    }

    @objc private func buttonTapped() {
        dismiss(animated: true)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}
