//
//  TabBarController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 18.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPersistentContainer = CoreDataPersistentContainer()
        let trackerStore = TrackerStore(context: coreDataPersistentContainer.context)
        let trackerCategoryStore = TrackerCategoryStore(context: coreDataPersistentContainer.context, trackerStore: trackerStore)
        let trackerRecordStore = TrackerRecordStore(context: coreDataPersistentContainer.context)
        let trackerDataController = TrackerDataController(trackerStore: trackerStore, trackerCategoryStore: trackerCategoryStore, trackerRecordStore: trackerRecordStore, context: coreDataPersistentContainer.context)
        trackerCategoryStore.setTrackerDataController(trackerDataController.fetchResultController)

        let trackersViewController = TrackersViewController(trackerDataController: trackerDataController)
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        let statisticViewController = StatisticViewController()

        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), selectedImage: nil)
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), selectedImage: nil)

        self.viewControllers = [trackersNavigationController, statisticViewController]

        tabBar.isTranslucent = false
        view.tintColor = .ypBlue

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
