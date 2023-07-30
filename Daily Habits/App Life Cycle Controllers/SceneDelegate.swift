//
//  SceneDelegate.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let appConfig = AppInitialConfiguration()
        let tabBarController = TabBarController(appInitialConfiguration: appConfig)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}

