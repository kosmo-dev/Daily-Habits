//
//  TrackerCategoryStore.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 07.07.2023.
//

import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case noTrackerInTrackerCategory
    case decodingError
    case fetchError
}

protocol TrackerCategoryStoreProtocol {
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func convertTrackerCategoryCoreDataToTrackerCategory(_ objects: [TrackerCategoryCoreData]) throws -> [TrackerCategory]
    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory]
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var trackerStore: TrackerStoreProtocol

    init(context: NSManagedObjectContext, trackerStore: TrackerStoreProtocol) {
        self.context = context
        self.trackerStore = trackerStore
        super.init()
    }
}

// MARK: - TrackerCategoryStoreProtocol
extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        guard let tracker = trackerCategory.trackers.first else { throw TrackerCategoryStoreError.noTrackerInTrackerCategory}
        let trackerCoreData = trackerStore.convertTrackerToTrackerCoreData(tracker)

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

    func fetchCategoriesWithPredicate(_ predicate: NSPredicate) -> [TrackerCategory] {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        fetchRequest.predicate = predicate

        do {
            let trackersCoreData = try context.fetch(fetchRequest)
            let groupedTrackers = Dictionary(grouping: trackersCoreData) { $0.trackerCategory?.name }
            var trackerCategories: [TrackerCategory] = []
            for (key, value) in groupedTrackers {
                let trackers = try value.map({ try trackerStore.convertTrackerCoreDataToTracker($0) })
                guard let key else { return [] }
                let trackerCategory = TrackerCategory(name: key, trackers: trackers)
                trackerCategories.append(trackerCategory)
            }
            return trackerCategories
        } catch {
            return []
        }
    }

    func convertTrackerCategoryCoreDataToTrackerCategory(_ objects: [TrackerCategoryCoreData]) throws -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        for object in objects {
            guard let name = object.name,
                  let trackersSet = object.trackers
            else {
                throw TrackerCategoryStoreError.decodingError
            }
            let trackers = Array(trackersSet.compactMap({ try? trackerStore.convertTrackerCoreDataToTracker($0 as! TrackerCoreData) }))
            let category = TrackerCategory(name: name, trackers: trackers)
            categories.append(category)
        }
        return categories
    }
}
