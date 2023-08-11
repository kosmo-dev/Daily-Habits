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
    let statisticNavigationCOntroller: UINavigationController
    let statisticViewController: StatisticViewController
    let statisticViewModel: StatisticViewModel

    let appMetricController: AppMetric

    init() {
        coreDataPersistentContainer = CoreDataPersistentContainer()
        trackerStore = TrackerStore(context: coreDataPersistentContainer.context)
        trackerCategoryStore = TrackerCategoryStore(context: coreDataPersistentContainer.context, trackerStore: trackerStore)
        trackerRecordStore = TrackerRecordStore(context: coreDataPersistentContainer.context)
        trackerDataController = TrackerDataController(trackerStore: trackerStore, trackerCategoryStore: trackerCategoryStore, trackerRecordStore: trackerRecordStore, context: coreDataPersistentContainer.context)
        trackerCategoryStore.setTrackerDataController(trackerDataController.fetchResultController)
        appMetricController = AppMetric()

        trackersViewModel = TrackersViewModel(categoriesController: trackerDataController, recordsController: trackerDataController, appMetricController: appMetricController)
        trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersViewModel.navigationController = trackersNavigationController
        statisticViewModel = StatisticViewModel(dataController: trackerDataController)
        statisticViewController = StatisticViewController(viewModel: statisticViewModel)
        statisticNavigationCOntroller = UINavigationController(rootViewController: statisticViewController)
    }
}
