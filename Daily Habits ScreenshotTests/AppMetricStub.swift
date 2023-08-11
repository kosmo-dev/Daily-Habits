//
//  AppMetricStub.swift
//  Daily Habits ScreenshotTests
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import Foundation
@testable import Daily_Habits

class AppMetricStub: AppMetricProtocol {
    func reportEvent(screen: String, event: Daily_Habits.AppMetricParams.Event, item: Daily_Habits.AppMetricParams.Item?) {}
}
