//
//  NewTrackerTypeChoosingViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import UIKit

final class NewTrackerTypeChoosingViewController: UIViewController {
// MARK: - Private Properties
    private let habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.tintColor = .ypWhite
        button.setTitle("Привычка", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let eventbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.tintColor = .ypWhite
        button.setTitle("Нерегулярное событие", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        navigationItem.title = "Создание трекера"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(habitButton)
        view.addSubview(eventbutton)

        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            eventbutton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventbutton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
