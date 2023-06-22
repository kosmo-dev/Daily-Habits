//
//  ScheduleViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Private Properties
    private let days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private var list = [ListView]()

    private let confirmButton = PrimaryButton(title: "Готово", action: #selector(confirmButtonTapped), type: .primary)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureList()
        configureView()
    }

    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Расписание"
        navigationItem.hidesBackButton = true

        view.addSubview(stackView)
        view.addSubview(confirmButton)
        list.forEach({ stackView.addArrangedSubview($0) })

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        list.forEach({ $0.heightAnchor.constraint(equalToConstant: 75).isActive = true })

    }

    private func configureList() {
        list.append(ListView(viewMaskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bottomDividerIsHidden: false, primaryText: days[0]))
        for day in 1..<days.count - 1 {
            list.append(ListView(viewMaskedCorners: [], bottomDividerIsHidden: false, primaryText: days[day]))
        }
        let lastIndex = days.count - 1
        list.append(ListView(viewMaskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], bottomDividerIsHidden: true, primaryText: days[lastIndex]))
    }

    @objc private func confirmButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
