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
    func updateTrackerProperties(for tracker: Tracker) throws
    func deleteTracker(_ trackerID: String) throws
}

final class TrackerStore {
    enum TrackerStoreError: Error {
        case errorGetTrackerById
        case errorUpdateTracker
    }

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
    func updateTrackerProperties(for tracker: Tracker) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: C.CoreDataEntityNames.trackerCoreData)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), tracker.id)
        guard let trackerCoreData = try context.fetch(request).first else {
            throw TrackerStoreError.errorGetTrackerById
        }
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.isPinned = tracker.isPinned
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = convertToScheduleCoreData(tracker.schedule)
        try context.save()
    }

    func convertTrackerCoreDataToTracker(_ object: TrackerCoreData) throws -> Tracker {
        guard let id = object.trackerID,
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
            schedule: schedule,
            isPinned: object.isPinned
        )
        return tracker
    }

    func convertTrackerToTrackerCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerID = tracker.id
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = convertToScheduleCoreData(tracker.schedule)
        trackerCoreData.isPinned = tracker.isPinned
        return trackerCoreData
    }

    func deleteTracker(_ trackerID: String) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: C.CoreDataEntityNames.trackerCoreData)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerID), trackerID)
        guard let trackerCoreData = try context.fetch(request).first else {
            throw TrackerStoreError.errorGetTrackerById
        }
        context.delete(trackerCoreData)
        try context.save()
    }
}
