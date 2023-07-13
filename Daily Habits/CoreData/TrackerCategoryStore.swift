//
//  TrackerCategoryStore.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 07.07.2023.
//

import Foundation
import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case noTrackerInTrackerCategory
    case decodingError
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        guard let tracker = trackerCategory.trackers.first else { throw TrackerCategoryStoreError.noTrackerInTrackerCategory}
        let trackerCoreData = convertTrackerToTrackerCoreData(tracker)

        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.name), trackerCategory.name)
        do {
            let categories = try context.fetch(request)

            if let category = categories.first {
                category.addToTrackers(trackerCoreData)
            } else {
                let newCategoryCoreData = TrackerCategoryCoreData(context: context)
                newCategoryCoreData.name = trackerCategory.name
                newCategoryCoreData.addToTrackers(trackerCoreData)
            }
            try context.save()
        } catch {
            print("Could not save. Error \(error)")
        }
    }

    func fetchCategoriesFor(weekday: Int) -> NSFetchRequest<TrackerCategoryCoreData> {
        let requestTrackers = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        requestTrackers.predicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        guard let trackers = try? context.fetch(requestTrackers) else { return }
        let trackersIDs = trackers.map({ $0.id })

        let requestTrackerCategory = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        requestTrackerCategory.predicate = NSPredicate(format: "ANY trackers.id IN %@", trackersIDs)
    }

    func convertTrackerCategoryCoreDataToTrackerCategory(_ objects: [TrackerCategoryCoreData]) throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        for object in objects {
            guard let name = object.name,
                  let trackersSet = object.trackers
            else {
                throw TrackerCategoryStoreError.decodingError
            }
            let trackers = Array(trackersSet.compactMap({ try? convertTrackerCoreDataToTracker($0 as! TrackerCoreData) }))
            let category = TrackerCategory(name: name, trackers: trackers)
            categories.append(category)
        }
        return categories
    }

    private func convertTrackerCoreDataToTracker(_ object: TrackerCoreData) throws -> Tracker {
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
            color: UIColor().color(from: colorString),
            emoji: emoji,
            schedule: schedule
        )
        return tracker
    }

    private func convertTrackerToTrackerCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = convertToScheduleCoreData(tracker.schedule)
        return trackerCoreData
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
