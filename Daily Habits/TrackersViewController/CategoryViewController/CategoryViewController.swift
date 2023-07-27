//
//  CategoryViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 23.06.2023.
//

import UIKit

//protocol CategoryViewControllerDelegate: AnyObject {
//    func addCategory(_ category: String, index: Int)
//}

final class CategoryViewController: UIViewController {
    // MARK: - Public Properties
//    weak var delegate: CategoryViewControllerDelegate?

    // MARK: - Private Properties
    private var viewModel: CategoryViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let addCategoryButton = PrimaryButton(title: "Добавить категорию", action: #selector(addCategoryButtonTapped), type: .primary)

    // MARK: - Initializers
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBindings()

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Private Methods
    private func configureView() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryTableViewCell")
        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true

        view.addSubview(addCategoryButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24)
        ])
    }

    private func configureMaskedCornersAndBottomDivider(for cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var bottomDividerIsHidden = false
        var maskedCorners: CACornerMask = []
        if indexPath.row == 0 {
            maskedCorners = upperMaskedCorners
        }
        if indexPath.row == viewModel.categories.count - 1 {
            maskedCorners = lowerMaskedCorners
            bottomDividerIsHidden = true
        }
        if viewModel.categories.count == 1 {
            maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            bottomDividerIsHidden = true
        }

        cell.setBottomDividerHidded(bottomDividerIsHidden)
        cell.setMaskedCorners(maskedCorners)
    }

    @objc private func addCategoryButtonTapped() {
        viewModel.addCategoryButtonTapped()
    }

    private func setBindings() {
        viewModel.$categories.bind { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadData()
        }

        viewModel.$alertText.bind { [weak self] text in
            guard let self, let text else { return }
            self.showAlertController(with: text)
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell") as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let text = viewModel.categories[indexPath.row]
        let hideCheckMarkImage = viewModel.hideCheckMarkImage(for: indexPath)
        cell.setPrimaryText(text: text)
        cell.hideCheckMarkImage(hideCheckMarkImage)
        configureMaskedCornersAndBottomDivider(for: cell, at: indexPath)
        return cell
    }
}

// MARK: - Alert Presentation
extension CategoryViewController {
    func showAlertController(with message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
