//
//  NewTrackerViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: - Private Properties
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.backgroundColor = .ypBackground
        titleTextField.layer.cornerRadius = 16
        titleTextField.layer.masksToBounds = true
        titleTextField.setLeftPaddingPoints(16)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    }()

    let cancelButton = PrimaryButton(title: "Отменить", action: #selector(cancelButtonTapped), type: .cancel)
    let saveButton = PrimaryButton(title: "Создать", action: #selector(saveButtonTapped), type: .notActive)
    let categoryView = ListView(viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bottomDividerIsHidden: false, primaryText: "Категория", action: #selector(categoryViewButtonTapped))
    let scheduleView = ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: "Расписание", action: #selector(scheduleViewButtonTapped))

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true

        categoryView.translatesAutoresizingMaskIntoConstraints = false
        scheduleView.translatesAutoresizingMaskIntoConstraints = false

        [titleTextField, categoryView, scheduleView, cancelButton, saveButton].forEach({ view.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            categoryView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            categoryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            categoryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            categoryView.heightAnchor.constraint(equalToConstant: 75),

            scheduleView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scheduleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scheduleView.heightAnchor.constraint(equalToConstant: 75),

            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func cancelButtonTapped() {
    }

    @objc private func saveButtonTapped() {
    }

    @objc private func categoryViewButtonTapped() {
    }

    @objc private func scheduleViewButtonTapped() {
        let viewController = ScheduleViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
