//
//  NewTrackerTypeChoosingViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import UIKit

final class NewTrackerTypeChoosingViewController: UIViewController {
    // MARK: - Private Properties
    private let habitButton = PrimaryButton(title: "Привычка", action: #selector(habitButtonTapped), type: .primary)
    private let eventButton = PrimaryButton(title: "Нерегулярное событие", action: #selector(eventButtonTapped), type: .primary)

    private var newTrackerViewController: UIViewController?
    private var newHabitVIewController: UIViewController?

    // MARK: Initializers
    init(newTrackerViewController: UIViewController?, newHabitVIewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.newTrackerViewController = newTrackerViewController
        self.newHabitVIewController = newHabitVIewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        
        navigationItem.title = "Создание трекера"
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
        guard let newTrackerViewController else { return }
        navigationController?.pushViewController(newTrackerViewController, animated: true)
    }

    @objc private func eventButtonTapped() {

    }
}

