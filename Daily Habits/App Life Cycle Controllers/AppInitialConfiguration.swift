//
//  AppInitialConfiguration.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 30.07.2023.
//

import UIKit

class AppInitialConfiguration {
    let coreDataPersistentContainer: CoreDataPersistentContainer
    let trackerStore: TrackerStore
    let trackerCategoryStore: TrackerCategoryStore
    let trackerRecordStore: TrackerRecordStore
    let trackerDataController: TrackerDataController

    let trackersViewModel: TrackersViewModel
    let trackersViewController: TrackersViewController
    let trackersNavigationController: UINavigationController
    let statisticViewController: StatisticViewController

    init() {
        coreDataPersistentContainer = CoreDataPersistentContainer()
        trackerStore = TrackerStore(context: coreDataPersistentContainer.context)
        trackerCategoryStore = TrackerCategoryStore(context: coreDataPersistentContainer.context, trackerStore: trackerStore)
        trackerRecordStore = TrackerRecordStore(context: coreDataPersistentContainer.context)
        trackerDataController = TrackerDataController(trackerStore: trackerStore, trackerCategoryStore: trackerCategoryStore, trackerRecordStore: trackerRecordStore, context: coreDataPersistentContainer.context)
        trackerCategoryStore.setTrackerDataController(trackerDataController.fetchResultController)

        trackersViewModel = TrackersViewModel(trackerDataController: trackerDataController)
        trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersViewModel.navigationController = trackersNavigationController
        statisticViewController = StatisticViewController()
    }
}
