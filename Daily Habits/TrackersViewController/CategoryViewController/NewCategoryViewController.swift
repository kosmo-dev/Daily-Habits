//
//  NewCategoryViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 20.07.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(_ category: String)
}

final class NewCategoryViewController: UIViewController {

    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = S.NewCategoryViewController.textFieldPlaceholder
        titleTextField.backgroundColor = .ypBackground
        titleTextField.layer.cornerRadius = 16
        titleTextField.layer.masksToBounds = true
        titleTextField.setLeftPaddingPoints(16)
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.addTarget(nil, action: #selector(textFieldEditingChanged), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        return titleTextField
    }()

    private let button = PrimaryButton(title: S.NewTrackerViewController.createButton, action: #selector(saveButtonTapped), type: .notActive)
    weak var delegate: NewCategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        titleTextField.delegate = self
    }

    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = S.NewCategoryViewController.navigationTitle
        navigationItem.hidesBackButton = true

        view.addSubview(titleTextField)
        view.addSubview(button)
        button.isEnabled = false

        NSLayoutConstraint.activate( [
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    @objc private func saveButtonTapped() {
        if let category = titleTextField.text {
            delegate?.addNewCategory(category)
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func textFieldEditingChanged() {
        checkTextField()
    }

    private func checkTextField() {
        if titleTextField.text != "" {
            button.configureButtonType(.primary)
            button.isEnabled = true
        } else {
            button.configureButtonType(.notActive)
            button.isEnabled = false
        }
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
