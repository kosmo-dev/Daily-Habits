//
//  NewTrackerViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.07.2023.
//

import UIKit

protocol NewTrackerViewModelDelegate: AnyObject {
    func addNewTracker(_ trackerCategory: TrackerCategory)
}

final class NewTrackerViewModel {
    enum Sections {
        case textField
        case listButtonViews
        case emojiLabel
        case emojisCollection
        case colorLabel
        case colorCollection
        case buttons
    }

    enum TrackerType {
        case habit
        case event
    }
    
    private var navigationController: UINavigationController?
    let emojis = C.Emojis.emojis
    let colors = C.Colors.colors

    let sections: [Sections] = [.textField, .listButtonViews, .emojiLabel, .emojisCollection, .colorLabel, .colorCollection, .buttons]
    let trackerType: TrackerType
    weak var delegate: NewTrackerViewModelDelegate?

    @Observable private(set) var category: String?
    @Observable private(set) var buttonIsEnabled = false
    @Observable private(set) var weekdaysTitle: String?
    @ObservableWithOldValue private(set) var selectedEmojiCellIndexPath: IndexPath?
    @ObservableWithOldValue private(set) var selectedColorCellIndexPath: IndexPath?

    private var titleTextFieldText: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    private var categoriesController: TrackerDataControllerCategoriesProtocol

    init(trackerType: TrackerType,
         navigationController: UINavigationController?,
         categoriesController: TrackerDataControllerCategoriesProtocol
    ) {
        self.trackerType = trackerType
        self.navigationController = navigationController
        self.categoriesController = categoriesController
        
        if trackerType == .event {
            choosedDays = Array(0...6)
        }
    }

    func saveButtonTapped(text: String) {
        guard buttonIsEnabled else { return }
        guard let category = category,
              let selectedEmojiCellIndexPath,
              let selectedColorCellIndexPath
        else {
            return
        }
        let emoji = emojis[selectedEmojiCellIndexPath.row]
        let color = colors[selectedColorCellIndexPath.row]
        let newTracker = TrackerCategory(name: category, trackers: [Tracker(id: UUID().uuidString, name: text, color: color, emoji: emoji, schedule: choosedDays, isPinned: false)])
        delegate?.addNewTracker(newTracker)
    }

    func setTitleText(text: String?) {
        titleTextFieldText = text
        checkFormCompletion()
    }

    func checkFormCompletion() {
        if titleTextFieldText?.isEmpty == false,
           category != nil,
           choosedDays.isEmpty == false,
           selectedEmojiCellIndexPath != nil,
           selectedColorCellIndexPath != nil
        {
            buttonIsEnabled = true
        } else {
            buttonIsEnabled = false
        }
    }

    func didSelectItem(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if section == .emojisCollection  {
            selectedEmojiCellIndexPath = indexPath
        } else if section == .colorCollection {
            selectedColorCellIndexPath = indexPath
        } else if section == .listButtonViews {
            if trackerType == .event {
                categoryViewButtonTapped()
            } else if indexPath.row == 0 {
                categoryViewButtonTapped()
            } else {
                scheduleViewButtonTapped()
            }
        }
        checkFormCompletion()
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .textField, .emojiLabel, .colorLabel:
            return 1
        case .listButtonViews:
            if trackerType == .habit {
                return 2
            } else {
                return 1
            }
        case .emojisCollection:
            return emojis.count
        case .colorCollection:
            return colors.count
        case .buttons:
            return 2
        }
    }

    private func categoryViewButtonTapped() {
        let categoryViewModel = CategoryViewModel(choosedCategoryIndex: choosedCategoryIndex, navigationController: navigationController, categoriesController: categoriesController)
        let viewController = CategoryViewController(viewModel: categoryViewModel)
        categoryViewModel.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func scheduleViewButtonTapped() {
        let viewModel = ScheduleViewModel(choosedDays: choosedDays, navigationController: navigationController)
        let viewController = ScheduleViewController(viewModel: viewModel)
        viewModel.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension NewTrackerViewModel: CategoryViewModelDelegate {
    func addCategory(_ category: String, index: Int) {
        self.category = category
        choosedCategoryIndex = index
        checkFormCompletion()
    }
}

extension NewTrackerViewModel: ScheduleViewModelDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        if weekdays.count == 7 {
            weekdaysTitle = S.NewTrackerViewController.scheduleEveryDaySecondaryText
            return
        }
        var daysView = ""
        for index in choosedDays {
            let calendar = Calendar.current
            let day = calendar.shortWeekdaySymbols[index]
            daysView.append(day)
            daysView.append(", ")
        }
        weekdaysTitle = String(daysView.dropLast(2))
        checkFormCompletion()
    }
}
