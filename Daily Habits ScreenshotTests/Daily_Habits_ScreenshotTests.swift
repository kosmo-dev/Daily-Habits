//
//  Daily_Habits_ScreenshotTests.swift
//  Daily Habits ScreenshotTests
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Daily_Habits

final class Daily_Habits_ScreenshotTests: XCTestCase {

    func testTrackersViewController() {
        let categoriesController = CategoriesControllerStub()
        let recordsController = RecordsControllerStub()
        let appMetric = AppMetricStub()
        let trackersViewModel = TrackersViewModel(categoriesController: categoriesController, recordsController: recordsController, appMetricController: appMetric)
        let trackersViewController = TrackersViewController(viewModel: trackersViewModel)
        categoriesController.delegate = trackersViewModel

        assertSnapshots(matching: trackersViewController, as: [.image(traits: .init(userInterfaceStyle: .light))])
        assertSnapshots(matching: trackersViewController, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }

}
