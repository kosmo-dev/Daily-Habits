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

        view.tintColor = .ypBlue

        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), selectedImage: nil)

        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), selectedImage: nil)

        self.viewControllers = [trackersNavigationController, statisticViewController]
    }
}
