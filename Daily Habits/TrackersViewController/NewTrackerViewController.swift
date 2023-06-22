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

    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()

    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.layer.cornerRadius = 16
        saveButton.layer.masksToBounds = true
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.backgroundColor = .ypGray
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        return saveButton
    }()

    let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let categoryButton = NewTrackerListButton(frame: .zero, viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
                                              bottomDividerIsHidden: false,
                                              primaryText: "Категория")
    let scheduleButton = NewTrackerListButton(frame: .zero,
                                              viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner],
                                              bottomDividerIsHidden: true,
                                              primaryText: "Расписание")

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

        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false

        [titleTextField, categoryButton, scheduleButton, cancelButton, categoryStackView, saveButton].forEach({ view.addSubview($0) })

        let padding: CGFloat = 16

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            categoryButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),

            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scheduleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),

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
}
