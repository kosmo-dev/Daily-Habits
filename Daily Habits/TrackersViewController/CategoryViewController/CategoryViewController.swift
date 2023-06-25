//
//  CategoryViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 23.06.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func addCategory(_ category: String, index: Int)
}

final class CategoryViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties
    private var categories = ["Важное", "Не важное"]
    private var categoriesView = [ListView]()
    private var choosedCategoryIndex: Int?

    private let addCategoryButton = PrimaryButton(title: "Добавить категорию", action: #selector(addCategoryButtonTapped), type: .primary)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let tableView = UITableView()

    // MARK: - Initializers
    init(choosedCategoryIndex: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.choosedCategoryIndex = choosedCategoryIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListView()
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true

        view.addSubview(stackView)
        view.addSubview(addCategoryButton)

        categoriesView.forEach({ stackView.addArrangedSubview($0) })

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        categoriesView.forEach({ $0.heightAnchor.constraint(equalToConstant: 75).isActive = true })
    }

    private func configureListView() {
        let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var bottomDividerIsHidden = false

        for category in 0..<categories.count {
            var maskedCorners: CACornerMask = []
            if category == 0 {
                maskedCorners = upperMaskedCorners
            }
            if category == categories.count - 1 {
                maskedCorners = lowerMaskedCorners
                bottomDividerIsHidden = true
            }
            if categories.count == 1 {
                maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                bottomDividerIsHidden = true
            }
            let view = ListView(viewMaskedCorners: maskedCorners, bottomDividerIsHidden: bottomDividerIsHidden, primaryText: categories[category], type: .checkmark, action: #selector(categoryButtonTapped))
            view.hideCheckMarkImage(true)
            if category == choosedCategoryIndex {
                view.hideCheckMarkImage(false)
            }
            categoriesView.append(view)
        }
    }

    @objc private func categoryButtonTapped(sender: ListButton) {
        guard let primaryText = sender.getPrimaryText(), let index = categories.firstIndex(where: { $0 == primaryText }) else { return }
        choosedCategoryIndex = index
        sender.hideCheckMarkImage(false)
        if let choosedCategoryIndex {
            delegate?.addCategory(categories[choosedCategoryIndex], index: index)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc private func addCategoryButtonTapped() {
    }
}
