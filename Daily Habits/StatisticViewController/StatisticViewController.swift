//
//  StatisticViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 18.06.2023.
//

import UIKit

final class StatisticViewController: UIViewController {

    private let placeholderImageView: UIImageView = {
        let placeholderImageView = UIImageView()
        placeholderImageView.image = UIImage(named: C.UIImages.statisticPlaceholder)
        placeholderImageView.isHidden = true
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImageView
    }()

    private let placeholderText: UILabel = {
        let placeholderText = UILabel()
        placeholderText.text = S.StatisticViewController.placeholderText
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderText.textColor = .ypBlack
        placeholderText.textAlignment = .center
        placeholderText.numberOfLines = 0
        placeholderText.isHidden = true
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        return placeholderText
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypWhite
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let viewModel: StatisticViewModel

    init(viewModel: StatisticViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setBindings()
        tableView.dataSource = self
        viewModel.getStatisticInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getStatisticInfo()
    }

    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = S.StatisticViewController.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(StatisticCellView.self, forCellReuseIdentifier: "StatisticCellView")
        [placeholderImageView, placeholderText, tableView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),

            placeholderText.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private func setBindings() {
        viewModel.$dataSource.bind { [weak self] data in
            guard let self else { return }
            if data.isEmpty == false {
                tableView.isHidden = false
                placeholderImageView.isHidden = true
                placeholderText.isHidden = true
                tableView.reloadData()
            } else {
                tableView.isHidden = true
                placeholderImageView.isHidden = false
                placeholderText.isHidden = false
            }
        }
    }
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCellView") as? StatisticCellView else {
            return UITableViewCell()
        }
        let counter = viewModel.dataSource[indexPath.row].counter
        let description = viewModel.dataSource[indexPath.row].description
        cell.configureCell(counterText: "\(counter)", desciptionText: description)
        return cell
    }
}
