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
    @Observable private(set) var trackersCollectionViewUpdate: TrackersCollectionViewUpdate?

    // MARK: - Private Properties
    private var currentDate: Date = Date()
    private var currentWeekday: Int {
        Calendar.current.component(.weekday, from: currentDate)-1
    }

    private var insertedIndexesInSearch: [IndexPath] = []
    private var removedIndexesInSearch: [IndexPath] = []
    private var insertedSectionsInSearch: IndexSet = []
    private var removedSectionsInSearch: IndexSet = []

    private var categoriesController: TrackerDataControllerCategoriesProtocol
    private var recordsController: TrackerDataControllerRecordsProtocol
    private var appMetricController: AppMetricProtocol

    private var trackersUpdate: TrackersCollectionViewUpdate?

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()

    private let appMetricScreenName = "main"

    // MARK: - Initializer
    init(categoriesController: TrackerDataControllerCategoriesProtocol,
         recordsController: TrackerDataControllerRecordsProtocol,
         appMetricController: AppMetricProtocol)
    {
        self.categoriesController = categoriesController
        self.recordsController = recordsController
        self.appMetricController = appMetricController
        configure()
    }

    // MARK: - Public Methods
    func datePickerValueChanged(_ date: Date) {
        currentDate = date
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        categoriesController.fetchCategoriesFor(weekday: weekday, animating: true)
    }

    func checkNeedPlaceholder(for state: PlaceholderState) {
        if visibleCategories.isEmpty {
            switch state {
            case .noTrackers:
                placeholderImage = UIImage(named: C.UIImages.emptyTrackersPlaceholder)
                placeholderText = S.TrackersViewController.emptyTrackersPlaceholder
            case .notFound:
                placeholderImage = UIImage(named: C.UIImages.searchNotFoundPlaceholder)
                placeholderText = S.TrackersViewController.notFoundPlaceholder
            }
        } else {
            placeholderImage = nil
            placeholderText = nil
        }
    }

    func checkButtonOnCellTapped(cellViewModel: CardCellViewModel) {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .track)
        do {
            if cellViewModel.buttonIsChecked {
                try recordsController.addTrackerRecord(id: cellViewModel.tracker.id, date: dateFormatter.string(from: currentDate))
            } else {
                try recordsController.deleteTrackerRecord(id: cellViewModel.tracker.id, date: dateFormatter.string(from: currentDate))
            }
            categoriesController.fetchCategoriesFor(weekday: currentWeekday, animating: false)
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorAddingTracker
        }
    }

    func performSearchFor(text: String) {
        categoriesController.fetchSearchedCategories(textToSearch: text, weekday: currentWeekday)
    }

    func leftBarButtonTapped() {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .add_track)
        let newTrackerTypeChoosingviewController = NewTrackerTypeChoosingViewController(trackersViewController: self, categoriesController: categoriesController, appMetricController: appMetricController)
        let modalNavigationController = UINavigationController(rootViewController: newTrackerTypeChoosingviewController)
        navigationController?.present(modalNavigationController, animated: true)
    }

    func configureCellViewModel(for indexPath: IndexPath) -> CardCellViewModel {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let counter = recordsController.fetchRecordsCountForId(tracker.id)
        let cardIsChecked = recordsController.checkTrackerRecordExist(id: tracker.id, date: dateFormatter.string(from: currentDate))
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

    func viewControllerDidAppear() {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .open, item: nil)
    }

    func viewControllerDidDissapear() {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .close, item: nil)
    }

    func pinButtonTapped(for cellIndexPath: IndexPath) {
        var tracker = visibleCategories[cellIndexPath.section].trackers[cellIndexPath.row]
        tracker.isPinned = true
        do {
            try categoriesController.updateTrackerProperties(tracker)
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorPinTracker
        }
    }

    func unPinButtonTapped(for cellIndexPath: IndexPath) {
        var tracker = visibleCategories[cellIndexPath.section].trackers[cellIndexPath.row]
        tracker.isPinned = false
        do {
            try categoriesController.updateTrackerProperties(tracker)
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorPinTracker
        }
    }

    func editButtonTapped(for cellIndexPath: IndexPath) {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .edit)
        let tracker = visibleCategories[cellIndexPath.section].trackers[cellIndexPath.item]
        let daysCount = recordsController.fetchRecordsCountForId(tracker.id)
        showNewTrackerViewController(tracker, daysCount: daysCount)
    }

    func deleteButtonTapped(for cellIndexPath: IndexPath) {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .delete)
        let trackerID = visibleCategories[cellIndexPath.section].trackers[cellIndexPath.row].id
        do {
            try categoriesController.deleteTracker(trackerID)
            try recordsController.deleteRecords(for: trackerID)
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorDeleteTracker
        }
    }

    func filterButtonTapped() {
        appMetricController.reportEvent(screen: appMetricScreenName, event: .click, item: .filter)
    }

    // MARK: - Private methods
    private func configure() {
        self.categoriesController.delegate = self
        categoriesController.fetchCategoriesFor(weekday: currentWeekday, animating: false)
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
                if !newCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id && $0.viewCategory == item.viewCategory }) }) {
                    removedIndexes.append(IndexPath(item: index, section: section))
                }
            }
        }

        for (section, category) in newCategories.enumerated() {
            for (index, item) in category.trackers.enumerated() {
                if !visibleCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id && $0.viewCategory == item.viewCategory }) }) {
                    insertedIndexes.append(IndexPath(item: index, section: section))
                }
            }
        }

        if withDateChange {
            for (section, category) in newCategories.enumerated() {
                for (index, item) in category.trackers.enumerated() {
                    if visibleCategories.contains(where: { $0.trackers.contains(where: { $0.id == item.id && $0.viewCategory == item.viewCategory }) }) {
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

    private func selectionForPinnedCategory(categories: [TrackerCategory]) -> [TrackerCategory] {
        var pinnedTrackers: [Tracker] = []
        var newCategories: [TrackerCategory] = []
        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackers {
                if tracker.isPinned {
                    var updatedTracker = tracker
                    updatedTracker.viewCategory = C.Constants.pinnedHeader
                    pinnedTrackers.append(updatedTracker)
                } else {
                    trackers.append(tracker)
                }
            }
            newCategories.append(TrackerCategory(name: category.name, trackers: trackers))
        }
        if !pinnedTrackers.isEmpty {
            newCategories.insert(TrackerCategory(name: S.TrackersViewController.pinnedHeader, trackers: pinnedTrackers), at: 0)
        }
        return newCategories
    }

    private func showNewTrackerViewController(_ tracker: Tracker, daysCount: Int) {
        let viewModel = NewTrackerViewModel(
            trackerType: .edit,
            categoriesController: categoriesController,
            appMetricController: appMetricController,
            navigationController: nil,
            tracker: tracker,
            daysCount: daysCount
        )
        viewModel.delegate = self
        let viewController = NewTrackerViewController(viewModel: viewModel)
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        viewModel.navigationController = modalNavigationController
        navigationController?.present(modalNavigationController, animated: true)
    }
}

// MARK: - TrackerDataControllerDelegate
extension TrackersViewModel: TrackerDataControllerDelegate {
    func updateViewByController(_ update: TrackerCategoryStoreUpdate) {
        let newCategories = selectionForPinnedCategory(categories: categoriesController.categories)
        calculateDiff(newCategories: newCategories, withDateChange: true)
        visibleCategories = newCategories
        trackersCollectionViewUpdate = trackersUpdate
        checkNeedPlaceholder(for: .noTrackers)
    }

    func updateView(categories: [TrackerCategory], animating: Bool, withDateChange: Bool) {
        let newCategories = selectionForPinnedCategory(categories: categoriesController.categories)
        calculateDiff(newCategories: newCategories, withDateChange: withDateChange)
        visibleCategories = newCategories
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
            try categoriesController.addTrackerCategory(trackerCategory)
        } catch {
            alertText = S.TrackersViewController.alertControllerErrorAddingTracker
        }
    }
}
