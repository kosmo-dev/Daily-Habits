//
//  CategoriesControllerStub.swift
//  Daily Habits ScreenshotTests
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import Foundation
@testable import Daily_Habits

class CategoriesControllerStub: TrackerDataControllerCategoriesProtocol {
    func addTrackerCategory(_ trackerCategory: Daily_Habits.TrackerCategory) throws {}

    func fetchCategoriesFor(weekday: Int, animating: Bool) {
        delegate?.updateView(categories: categories, animating: false, withDateChange: true)
    }

    func fetchSearchedCategories(textToSearch: String, weekday: Int) {}

    func addNewCategory(_ category: String) throws {}

    func fetchCategoriesList() -> [String] {
        return []
    }

    func updateTrackerProperties(_ tracker: Daily_Habits.Tracker) throws {}

    func deleteTracker(_ trackerID: String) throws {}

    var categories: [Daily_Habits.TrackerCategory] = [
        TrackerCategory(name: "Category 1", trackers: [
            Tracker(id: UUID().uuidString, name: "123", color: C.Colors.colors[0], emoji: C.Emojis.emojis[0], schedule: [0, 1, 2, 3, 4, 5, 6], isPinned: false, category: "Category 1", viewCategory: "Category 1"),
            Tracker(id: UUID().uuidString, name: "234", color: C.Colors.colors[1], emoji: C.Emojis.emojis[1], schedule: [0, 1, 2, 3, 4, 5, 6], isPinned: true, category: "Category 1", viewCategory: "Category 1")
        ]),
        TrackerCategory(name: "Category 2", trackers: [
            Tracker(id: UUID().uuidString, name: "345", color: C.Colors.colors[2], emoji: C.Emojis.emojis[2], schedule: [0, 1, 2, 3, 4, 5, 6], isPinned: false, category: "Category 2", viewCategory: "Category 2"),
            Tracker(id: UUID().uuidString, name: "456", color: C.Colors.colors[3], emoji: C.Emojis.emojis[3], schedule: [0, 1, 2, 3, 4, 5, 6], isPinned: false, category: "Category 2", viewCategory: "Category 2")
        ])
    ]
    var delegate: Daily_Habits.TrackerDataControllerDelegate?
}
