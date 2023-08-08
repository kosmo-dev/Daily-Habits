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
        case daysLabel
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
        case edit
    }
    
    var navigationController: UINavigationController?
    let emojis = C.Emojis.emojis
    let colors = C.Colors.colors

    let sections: [Sections] = [.daysLabel, .textField, .listButtonViews, .emojiLabel, .emojisCollection, .colorLabel, .colorCollection, .buttons]
    let trackerType: TrackerType
    weak var delegate: NewTrackerViewModelDelegate?

    @Observable private(set) var category: String?
    @Observable private(set) var buttonIsEnabled = false
    @Observable private(set) var weekdaysTitle: String?
    @ObservableWithOldValue private(set) var selectedEmojiCellIndexPath: IndexPath?
    @ObservableWithOldValue private(set) var selectedColorCellIndexPath: IndexPath?
    private(set) var daysTitle: String?
    private(set) var titleTextFieldText: String?
    
    private var choosedDays: [Int] = []
    private var categoriesController: TrackerDataControllerCategoriesProtocol
    private var tracker: Tracker?
    private var trackerIsPinned = false
    private var trackerID = UUID().uuidString

    init(trackerType: TrackerType,
         categoriesController: TrackerDataControllerCategoriesProtocol,
         navigationController: UINavigationController?
    ) {
        self.trackerType = trackerType
        self.categoriesController = categoriesController
        self.navigationController = navigationController
        
        if trackerType == .event {
            choosedDays = Array(0...6)
        }
    }

    convenience init(trackerType: TrackerType,
         categoriesController: TrackerDataControllerCategoriesProtocol,
         navigationController: UINavigationController?,
         tracker: Tracker,
         daysCount: Int
    ) {
        self.init(trackerType: trackerType, categoriesController: categoriesController, navigationController: navigationController)
        self.tracker = tracker
        self.daysTitle = String.localizedStringWithFormat(NSLocalizedString("%d days", comment: ""), daysCount)
    }

    func viewControllerDidLoad() {
        if let tracker {
            configureView(tracker)
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
        let newTracker = TrackerCategory(name: category, trackers: [Tracker(id: trackerID, name: text, color: color, emoji: emoji, schedule: choosedDays, isPinned: trackerIsPinned, category: category)])
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
            if trackerType == .event {
                return 1
            } else {
                return 2
            }
        case .emojisCollection:
            return emojis.count
        case .colorCollection:
            return colors.count
        case .buttons:
            return 2
        case .daysLabel:
            return trackerType == .edit ? 1 : 0
        }
    }

    private func categoryViewButtonTapped() {
        let categoryViewModel = CategoryViewModel(choosedCategory: category, navigationController: navigationController, categoriesController: categoriesController)
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

    private func configureView(_ tracker: Tracker) {
        setTitleText(text: tracker.name)
        addCategory(tracker.category)
        let sortedSchedule = tracker.schedule.sorted()
        addWeekDays(sortedSchedule)
        if let emojiIndex = tracker.emojiIndex,
           let colorIndex = tracker.colorIndex {
            selectedEmojiCellIndexPath = IndexPath(item: emojiIndex, section: 4)
            selectedColorCellIndexPath = IndexPath(item: colorIndex, section: 6)
        }
        trackerIsPinned = tracker.isPinned
        trackerID = tracker.id
        checkFormCompletion()
    }
}

extension NewTrackerViewModel: CategoryViewModelDelegate {
    func addCategory(_ category: String) {
        self.category = category
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
