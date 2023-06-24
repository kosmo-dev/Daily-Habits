//
//  ScheduleViewController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.06.2023.
//

import UIKit

enum Weekdays: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

protocol ScheduleViewControllerDelegate: AnyObject {
    func receiveWeekDays(_ weekdays: [Weekdays])
}

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?

    // MARK: - Private Properties
    private let days: [Weekdays] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    private var list = [ListButtonView]()
    private var finalList = [Weekdays]()

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
        let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var bottomDividerIsHidden = false

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
            list.append(ListButtonView(viewMaskedCorners: maskedCorners, bottomDividerIsHidden: bottomDividerIsHidden, primaryText: days[day].rawValue, type: .switcher, action: nil))
        }
    }

    @objc private func confirmButtonTapped() {
        for item in list {
            guard item.switcherIsOn() else { continue }
            guard let text = item.getPrimaryText() else { continue }
            guard let weekday = convertTextToWeekDays(text) else { continue }
            finalList.append(weekday)
        }
        delegate?.receiveWeekDays(finalList)
        navigationController?.popViewController(animated: true)
    }

    private func convertTextToWeekDays(_ text: String) -> Weekdays? {
        switch text {
        case Weekdays.monday.rawValue:
            return .monday
        case Weekdays.tuesday.rawValue:
            return .tuesday
        case Weekdays.wednesday.rawValue:
            return .wednesday
        case Weekdays.thursday.rawValue:
            return .thursday
        case Weekdays.friday.rawValue:
            return .friday
        case Weekdays.saturday.rawValue:
            return .saturday
        case Weekdays.sunday.rawValue:
            return .sunday
        default:
            return nil
        }
    }

}
