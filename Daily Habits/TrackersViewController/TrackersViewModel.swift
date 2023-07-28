//
//  TrackersViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.07.2023.
//

import UIKit

final class TrackersViewModel {
    enum PlaceholderState {
        case noTrackers
        case notFound
    }

    // MARK: - Public Properties
    var navigationController: UINavigationController?
    private(set) var visibleCategories: [TrackerCategory] = []

    @Observable private(set) var placeholderImage: UIImage?
    @Observable private(set) var placeholderText: String?
    @Observable private(set) var alertText: String?
    @Observable private(set) var itemsToReload: [IndexPath]?
    @Observable private(set) var trackersCollectionViewUpdate: TrackersCollectionViewUpdate?

    // MARK: - Private Properties
    private var currentDate: Date = Date()

    private var insertedIndexesInSearch: [IndexPath] = []
    private var removedIndexesInSearch: [IndexPath] = []
    private var insertedSectionsInSearch: IndexSet = []
    private var removedSectionsInSearch: IndexSet = []

    private let trackerDataController: TrackerDataControllerProtocol
    private var trackersUpdate: TrackersCollectionViewUpdate?

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    // MARK: - Initializer
    init(trackerDataController: TrackerDataControllerProtocol) {
        self.trackerDataController = trackerDataController
        configure()
    }

    // MARK: - Public Methods
    func datePickerValueChanged(_ date: Date) {
        currentDate = date
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchCategoriesFor(weekday: weekday, animating: true)
    }

    func checkNeedPlaceholder(for state: PlaceholderState) {
        if visibleCategories.isEmpty {
            switch state {
            case .noTrackers:
                placeholderImage = UIImage(named: C.UIImages.emptyTrackersPlaceholder)
                placeholderText = "Что будем отслеживать?"
            case .notFound:
                placeholderImage = UIImage(named: C.UIImages.searchNotFoundPlaceholder)
                placeholderText = "Ничего не найдено"
            }
        } else {
            placeholderImage = nil
            placeholderText = nil
        }
    }

    func checkButtonOnCellTapped(cellViewModel: CardCellViewModel) {
        do {
            if cellViewModel.buttonIsChecked {
                try trackerDataController.addTrackerRecord(id: cellViewModel.tracker.id, date: dateFormatter.string(from: currentDate))
            } else {
                try trackerDataController.deleteTrackerRecord(id: cellViewModel.tracker.id, date: dateFormatter.string(from: currentDate))
            }
            itemsToReload = [cellViewModel.indexPath]
        } catch {
            alertText = "Ошибка добавления записи. Попробуйте еще раз"
        }
    }

    func performSearchFor(text: String) {
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchSearchedCategories(textToSearch: text, weekday: weekday)
    }

    func leftBarButtonTapped() {
        let newTrackerTypeChoosingviewController = NewTrackerTypeChoosingViewController(trackersViewController: self, dataController: trackerDataController)
        let modalNavigationController = UINavigationController(rootViewController: newTrackerTypeChoosingviewController)
        navigationController?.present(modalNavigationController, animated: true)
    }

    func configureCellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let counter = trackerDataController.fetchRecordsCountForId(tracker.id)
        let cardIsChecked = trackerDataController.checkTrackerRecordExist(id: tracker.id, date: dateFormatter.string(from: currentDate))
        let dateComparision = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day)
        var buttonEnabled = true
        if dateComparision.rawValue == 1 {
            buttonEnabled = false
        }
        return CardCellViewModel(tracker: tracker, counter: counter, buttonIsChecked: cardIsChecked, indexPath: indexPath, buttonIsEnabled: buttonEnabled)
    }

    func viewControllerDidLoad() {
        checkNeedPlaceholder(for: .noTrackers)
        checkNeedOnboardingScreen()
    }

    // MARK: - Private methods
    private func configure() {
        self.trackerDataController.delegate = self
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchCategoriesFor(weekday: weekday, animating: false)
    }

    private func checkNeedOnboardingScreen() {
        guard visibleCategories.isEmpty else { return }
        let pageViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(pageViewController, animated: true)
    }

    private func calculateDiff(newCategories: [TrackerCategory], withDateChange: Bool) {
        var insertedIndexes: [IndexPath] = []
        var removedIndexes: [IndexPath] = []
        var reloadedIndexes: [IndexPath] = []
        var insertedSections: IndexSet = []
        var removedSections: IndexSet = []

        for (section, category) in visibleCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !newCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id }) }) {
                    removedIndexes.append(IndexPath(item: index, section: section))
                }
            }
        }

        for (section, category) in newCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !visibleCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id }) }) {
                    insertedIndexes.append(IndexPath(item: index, section: section))
                }
            }
        }

        if withDateChange {
            for (section, category) in visibleCategories.enumerated() {
                for (index, item) in category.trackers.enumerated() {
                    if newCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id }) }) {
                        reloadedIndexes.append(IndexPath(item: index, section: section))
                    }
                }
            }
        }

        for (section, category) in visibleCategories.enumerated() {
            if !newCategories.contains(where: { $0.name == category.name }) {
                removedSections.insert(section)
            }
        }

        for (section, category) in newCategories.enumerated() {
            if !visibleCategories.contains(where: { $0.name == category.name }) {
                insertedSections.insert(section)
            }
        }

        trackersUpdate = TrackersCollectionViewUpdate(
            insertedIndexesInSearch: insertedIndexes,
            removedIndexesInSearch: removedIndexes,
            reloadedIndexes: reloadedIndexes,
            insertedSectionsInSearch: insertedSections,
            removedSectionsInSearch: removedSections)
    }
}

// MARK: - TrackerDataControllerDelegate
extension TrackersViewModel: TrackerDataControllerDelegate {
    func updateViewByController(_ update: TrackerCategoryStoreUpdate) {
        let newCategories = trackerDataController.categories
        calculateDiff(newCategories: newCategories, withDateChange: true)
        visibleCategories = newCategories
        trackersCollectionViewUpdate = trackersUpdate
        checkNeedPlaceholder(for: .noTrackers)
    }

    func updateView(categories: [TrackerCategory], animating: Bool, withDateChange: Bool) {
        calculateDiff(newCategories: categories, withDateChange: withDateChange)
        visibleCategories = categories
        if animating {
            trackersCollectionViewUpdate = trackersUpdate
        } else {
            trackersCollectionViewUpdate = TrackersCollectionViewUpdate()
        }
        checkNeedPlaceholder(for: .notFound)
    }
}

// MARK: - NewTrackerViewModelDelegate
extension TrackersViewModel: NewTrackerViewModelDelegate {
    func addNewTracker(_ trackerCategory: TrackerCategory) {
        navigationController?.dismiss(animated: true)
        do {
            try trackerDataController.addTrackerCategory(trackerCategory)
        } catch {
            alertText = "Ошибка добавления нового трекера. Попробуйте еще раз"
        }
    }
}