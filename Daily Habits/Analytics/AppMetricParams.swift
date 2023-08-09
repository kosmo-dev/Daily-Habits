//
//  AppMetricParams.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import Foundation

enum AppMetricParams {
    enum Event: String {
        case open
        case close
        case click
    }
    enum Item: String {
        case add_track
        case track
        case filter
        case edit
        case delete

        case habitButton
        case eventButton

        case saveNewTracker
        case trackerCategory
        case trackerSchedule
        case emoji
        case color
    }
}
