//
//  NewTrackerTypeChoosingViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import UIKit

final class NewTrackerTypeChoosingViewController: UIViewController {
    weak var trackersViewController: NewTrackerViewModelDelegate?

    // MARK: - Private Properties
    private let habitButton = PrimaryButton(title: S.NewTrackerTypeChoosingViewController.habitButton, action: #selector(habitButtonTapped), type: .primary)
    private let eventButton = PrimaryButton(title: S.NewTrackerTypeChoosingViewController.eventButton, action: #selector(eventButtonTapped), type: .primary)
    private let categoriesController: TrackerDataControllerCategoriesProtocol
    private let appMetricController: AppMetricProtocol
    private let appMetricScreenName = "NewTrackerTypeChoosingViewController"

    // MARK: Initializers
    init(
        trackersViewController: NewTrackerViewModelDelegate?,
        categoriesController: TrackerDataControllerCategoriesProtocol,
        appMetricController: AppMetricProtocol
    ) {
        self.categoriesController = categoriesController
        self.appMetricController = appMetricController
        super.init(nibName: nil, bundle: nil)
        self.trackersViewController = trackersViewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        appMetricController.reportEvent(screen: appMetricScreenName, event: .open, item: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appMetricController.reportEvent(screen: appMetricScreenName, event: .close, item: nil)
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        
        navigationItem.title = S.NewTrackerTypeChoosingViewController.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(habitButton)
        view.addSubview(eventButton)

        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func habitButtonTapped() {
        showViewController(trackerType: .habit)
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .habitButton)
    }

    @objc private func eventButtonTapped() {
        showViewController(trackerType: .event)
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .eventButton)
    }

    private func showViewController(trackerType: NewTrackerViewModel.TrackerType) {
        let viewModel = NewTrackerViewModel(trackerType: trackerType, categoriesController: categoriesController, appMetricController: appMetricController, navigationController: navigationController)
        viewModel.delegate = trackersViewController
        let newTrackerViewController = NewTrackerViewController(viewModel: viewModel)
        navigationController?.pushViewController(newTrackerViewController, animated: true)
    }
}


