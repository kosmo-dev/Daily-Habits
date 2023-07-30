//
//  TrackerStore.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 06.07.2023.
//

import UIKit
import CoreData

protocol TrackerStoreProtocol {
    func convertTrackerCoreDataToTracker(_ object: TrackerCoreData) throws -> Tracker
    func convertTrackerToTrackerCoreData(_ tracker: Tracker) -> TrackerCoreData
}

final class TrackerStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    private func convertToScheduleCoreData(_ weekdays: [Int]) -> NSSet {
        var scheduleCoreDataSet: Set<ScheduleCoreData> = []
        for day in weekdays {
            let scheduleCoreData = ScheduleCoreData(context: context)
            scheduleCoreData.weekday = Int32(day)
            scheduleCoreDataSet.insert(scheduleCoreData)
        }
        return NSSet(set: scheduleCoreDataSet)
    }

    private func convertScheduleCoreDataToArray(_ scheduleSet: NSSet) -> [Int] {
        var scheduleArray: [Int] = []
        for element in scheduleSet {
            guard let scheduleCoreData = element as? ScheduleCoreData else { return [] }
            let day = scheduleCoreData.weekday
            scheduleArray.append(Int(day))
        }
        return scheduleArray
    }
}

// MARK: - TrackerStoreProtocol
extension TrackerStore: TrackerStoreProtocol {
    func convertTrackerCoreDataToTracker(_ object: TrackerCoreData) throws -> Tracker {
        guard let id = object.id,
              let name = object.name,
              let colorString = object.color,
              let emoji = object.emoji,
              let scheduleSet = object.schedule
        else {
            throw TrackerCategoryStoreError.decodingError
        }
        let schedule = convertScheduleCoreDataToArray(scheduleSet)
        let tracker = Tracker(
            id: id,
            name: name,
            color: UIColor.color(from: colorString),
            emoji: emoji,
            schedule: schedule
        )
        return tracker
    }

    func convertTrackerToTrackerCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = convertToScheduleCoreData(tracker.schedule)
        return trackerCoreData
    }
}
