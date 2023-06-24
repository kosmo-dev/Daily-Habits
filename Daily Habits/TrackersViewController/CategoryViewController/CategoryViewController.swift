//
//  CategoryViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 23.06.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func addCategory(_ category: String)
}

final class CategoryViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties
    private var categories = ["Важное", "Не важное"]
    private var categoriesView = [ListButtonView]()
    private var choosedCategoryIndex: Int?

    private let addCategoryButton = PrimaryButton(title: "Добавить категорию", action: #selector(addCategoryButtonTapped), type: .primary)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        choosedCategoryIndex = 0
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true

        view.addSubview(stackView)
        view.addSubview(addCategoryButton)

        categoriesView.append(ListButtonView(viewMaskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], bottomDividerIsHidden: true, primaryText: categories[0], type: .checkmark, action: nil))
        stackView.addArrangedSubview(categoriesView[0])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        categoriesView[0].heightAnchor.constraint(equalToConstant: 75).isActive = true
    }

    @objc private func categoryButtonTapped() {
        print("category button tapped")
    }

    @objc private func addCategoryButtonTapped() {
        if let choosedCategoryIndex {
            delegate?.addCategory(categories[choosedCategoryIndex])
        }
        navigationController?.popViewController(animated: true)
    }

}
