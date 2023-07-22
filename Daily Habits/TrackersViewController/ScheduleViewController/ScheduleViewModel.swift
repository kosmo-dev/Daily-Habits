//
//  ScheduleViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.07.2023.
//

import UIKit

protocol ScheduleViewModelDelegate: AnyObject {
    func addWeekDays(_ weekdays: [Int])
}

final class ScheduleViewModel {
    weak var delegate: ScheduleViewModelDelegate?
    var navigationController: UINavigationController?

    private var calendar = Calendar.current
    private var days = [String]()

    private(set) var list = [ListViewModel]()
    private(set) var finalList: [Int] = []

    init(choosedDays: [Int], navigationController: UINavigationController?) {
        self.navigationController = navigationController
        calendar.locale = Locale(identifier: "ru_RU")
        days = calendar.weekdaySymbols
        finalList = choosedDays
        configureDaysArray()
        configureList()
    }

    func configureButtonTapped(text: [String]) {
        finalList.removeAll()
        for item in text {
            guard let weekday = getIndexOfWeek(item) else { continue }
            finalList.append(weekday)
        }
        delegate?.addWeekDays(finalList)
        navigationController?.popViewController(animated: true)
    }

    private func configureList() {
        let upperMaskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let lowerMaskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        var bottomDividerIsHidden = false

        var choosedDays: [String] = []
        for item in finalList {
            choosedDays.append(calendar.weekdaySymbols[item])
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
//            let viewModel = ListView(viewMaskedCorners: maskedCorners, bottomDividerIsHidden: bottomDividerIsHidden, primaryText: days[day], type: .switcher, action: nil)
            var switcherIsOn = false
            if choosedDays.contains(where: { $0 == days[day].lowercased() }) {
                switcherIsOn = true
            }
            let viewModel = ListViewModel(maskedCorners: maskedCorners, bottomDividerIsHidden: bottomDividerIsHidden, primaryText: days[day], type: .switcher, action: nil, switcherIsOn: switcherIsOn)
            list.append(viewModel)
        }
    }

    private func configureDaysArray() {
        let weekdaySymbols = calendar.weekdaySymbols
        var weekdays: [String] = []

        for weekdaySymbol in weekdaySymbols {
            weekdays.append(weekdaySymbol.capitalizeFirstLetter())
        }

        guard let firstDay = weekdays.first else { return }
        weekdays.append(firstDay)
        weekdays.remove(at: 0)
        days = weekdays
    }

    private func getIndexOfWeek(_ text: String) -> Int? {
        return calendar.weekdaySymbols.firstIndex(of: text.lowercased())
    }
}
