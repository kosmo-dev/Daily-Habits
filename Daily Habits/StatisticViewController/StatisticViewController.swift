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

    private let cell = StatisticCellView()
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
        cell.configureCell(counterText: "", desciptionText: S.StatisticViewController.finishedTrackers)
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
        cell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cell)
        [placeholderImageView, placeholderText, cell].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),

            placeholderText.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            cell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cell.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func setBindings() {
        viewModel.$recordsCounterLabel.bind { [weak self] counter in
            guard let self else { return }
            if let counter, counter != 0 {
                cell.isHidden = false
                placeholderImageView.isHidden = true
                placeholderText.isHidden = true
                cell.configureCell(counterText: "\(counter)", desciptionText: S.StatisticViewController.finishedTrackers)
            } else {
                cell.isHidden = true
                placeholderImageView.isHidden = false
                placeholderText.isHidden = false
            }
        }
    }
}
