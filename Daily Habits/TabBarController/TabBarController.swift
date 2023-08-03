//
//  TabBarController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 18.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    let appInitialConfiguration: AppInitialConfiguration

    init(appInitialConfiguration: AppInitialConfiguration) {
        self.appInitialConfiguration = appInitialConfiguration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appInitialConfiguration.trackersViewController.tabBarItem = UITabBarItem(title: S.TabBarController.trackersTabBarItem, image: UIImage(systemName: "record.circle.fill"), selectedImage: nil)
        appInitialConfiguration.statisticViewController.tabBarItem = UITabBarItem(title: S.TabBarController.statisticsTabBarItem, image: UIImage(systemName: "hare.fill"), selectedImage: nil)

        self.viewControllers = [appInitialConfiguration.trackersNavigationController, appInitialConfiguration.statisticViewController]

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
