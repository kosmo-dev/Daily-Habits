//
//  ScheduleViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func addWeekDays(_ weekdays: [Int])
}

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?

    // MARK: - Private Properties
    private var calendar = Calendar.current
    private var days = [String]()

    private var list = [ListView]()
    private var finalList: [Int] = []

    private let confirmButton = PrimaryButton(title: "Готово", action: #selector(confirmButtonTapped), type: .primary)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Initializer
    init(choosedDays: [Int]) {
        days = calendar.weekdaySymbols
        finalList = choosedDays
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDaysArray()
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
        let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var bottomDividerIsHidden = false

        var choosedDays: [String] = []
        for item in finalList {
            choosedDays.append(Calendar.current.weekdaySymbols[item])
        }

        for day in 0..<days.count {
            var maskedCorners: CACornerMask = []
            if day == 0 {
                maskedCorners = upperMaskedCorners
            }
            if day == days.count - 1 {
                maskedCorners = lowerMaskedCorners
                bottomDividerIsHidden = true
            }
            if days.count == 1 {
                maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
                bottomDividerIsHidden = true
            }
            let view = ListView(viewMaskedCorners: maskedCorners, bottomDividerIsHidden: bottomDividerIsHidden, primaryText: days[day], type: .switcher, action: nil)
            if choosedDays.contains(where: { $0 == days[day].lowercased() }) {
                view.setSwitcherOn()
            }
            list.append(view)
        }
    }

    private func configureDaysArray() {
        let weekdaySymbols = Calendar.current.weekdaySymbols
        var weekdays: [String] = []

        for weekdaySymbol in weekdaySymbols {
            weekdays.append(weekdaySymbol.capitalizeFirstLetter())
        }

        guard let firstDay = weekdays.first else { return }
        weekdays.append(firstDay)
        weekdays.remove(at: 0)
        days = weekdays
    }

    @objc private func confirmButtonTapped() {
        finalList.removeAll()
        for item in list {
            guard item.switcherIsOn() else { continue }
            guard let text = item.getPrimaryText() else { continue }
            guard let weekday = getIndexOfWeek(text) else { continue }
            finalList.append(weekday)
        }
        delegate?.addWeekDays(finalList)
        navigationController?.popViewController(animated: true)
    }

    private func getIndexOfWeek(_ text: String) -> Int? {
        return Calendar.current.weekdaySymbols.firstIndex(of: text.lowercased())
    }
}
