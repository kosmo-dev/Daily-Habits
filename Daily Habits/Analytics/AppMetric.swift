//
//  AppMetric.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import Foundation
import YandexMobileMetrica

protocol AppMetricProtocol {
    func reportEvent(screen: String, event: AppMetricParams.Event, item: AppMetricParams.Item?)
}

class AppMetric: AppMetricProtocol {
    func reportEvent(screen: String, event: AppMetricParams.Event, item: AppMetricParams.Item?) {
        var params = ["screen": screen]
        if let item {
            params["item"] = item.rawValue
        }
        print("Event:", event.rawValue, params)
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params)
    }
}

