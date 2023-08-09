//
//  CategoryViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 23.06.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    // MARK: - Private Properties
    private var viewModel: CategoryViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let placeholderImageView: UIImageView = {
        let placeholderImageView = UIImageView()
        placeholderImageView.image = UIImage(named: C.UIImages.emptyTrackersPlaceholder)
        placeholderImageView.isHidden = true
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImageView
    }()

    private let placeholderText: UILabel = {
        let placeholderText = UILabel()
        placeholderText.text = S.CategoryViewController.placeholderText
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderText.textColor = .ypBlack
        placeholderText.textAlignment = .center
        placeholderText.numberOfLines = 0
        placeholderText.isHidden = true
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        return placeholderText
    }()

    private let addCategoryButton = PrimaryButton(title: S.CategoryViewController.addCategoryButton, action: #selector(addCategoryButtonTapped), type: .primary)

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

        viewModel.viewControllerDidLoad()
    }

    // MARK: - Private Methods
    private func configureView() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "categoryTableViewCell")
        view.backgroundColor = .ypWhite
        navigationItem.title = S.NewTrackerViewController.categoryHeader
        navigationItem.hidesBackButton = true

        [addCategoryButton, tableView, placeholderImageView, placeholderText].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -24),

            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func addCategoryButtonTapped() {
        viewModel.addCategoryButtonTapped()
    }

    private func setBindings() {
        viewModel.$categoriesModel.bind { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadData()
        }

        viewModel.$alertText.bind { [weak self] text in
            guard let self, let text else { return }
            self.showAlertController(with: text)
        }

        viewModel.$showPlaceholder.bind { [weak self] show in
            guard let self else { return }
            if show {
                self.placeholderText.isHidden = false
                self.placeholderImageView.isHidden = false
            } else {
                self.placeholderText.isHidden = true
                self.placeholderImageView.isHidden = true
            }
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
        return viewModel.categoriesModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell") as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(viewModel.categoriesModel[indexPath.row])
        return cell
    }
}

// MARK: - Alert Presentation
extension CategoryViewController {
    func showAlertController(with message: String) {
        let alertController = UIAlertController(title: S.TrackersViewController.alertControllerTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: S.TrackersViewController.alertControllerAction, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
