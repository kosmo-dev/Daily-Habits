//
//  ScheduleViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Private Properties
    private let confirmButton = PrimaryButton(title: S.ScheduleViewController.confirmButton, action: #selector(confirmButtonTapped), type: .primary)
    private var viewModel: ScheduleViewModel

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializer
    init(viewModel: ScheduleViewModel) {
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
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = S.NewTrackerViewController.scheduleHeader
        navigationItem.hidesBackButton = true

        view.addSubview(stackView)
        view.addSubview(confirmButton)
        viewModel.list.forEach({ stackView.addArrangedSubview(ListView(listViewModel: $0)) })

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        stackView.arrangedSubviews.forEach { $0.heightAnchor.constraint(equalToConstant: 75).isActive = true }

    }

    @objc private func confirmButtonTapped() {
        var list: [String] = []
        for item in stackView.arrangedSubviews {
            guard let view = item as? ListView,
                  view.switcherIsOn(),
                  let text = view.getPrimaryText() else { continue }
            list.append(text)
        }
        viewModel.configureButtonTapped(text: list)
    }
}
