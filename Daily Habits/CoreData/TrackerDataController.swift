//
//  TrackerDataController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 11.07.2023.
//

import Foundation
import CoreData

protocol TrackerDataControllerDelegate: AnyObject {
    func updateViewByController(_ update: TrackerCategoryStoreUpdate)
    func updateView(categories: [TrackerCategory], animating: Bool, withDateChange: Bool)
}

protocol TrackerDataControllerCategoriesProtocol {
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func fetchCategoriesFor(weekday: Int, animating: Bool)
    func fetchSearchedCategories(textToSearch: String, weekday: Int)
    func addNewCategory(_ category: String) throws
    func fetchCategoriesList() -> [String]
    func updateTrackerProperties(_ tracker: Tracker) throws
    func deleteTracker(_ trackerID: String) throws
    var categories: [TrackerCategory] { get }
    var delegate: TrackerDataControllerDelegate? { get set }
}

protocol TrackerDataControllerRecordsProtocol {
    func fetchRecordsCountForId(_ id: String) -> Int
    func checkTrackerRecordExist(id: String, date: String) -> Bool
    func addTrackerRecord(id: String, date: String) throws
    func deleteTrackerRecord(id: String, date: String) throws
    func fetchRecordsCount() -> Int?
    func deleteRecords(for id: String) throws
}

final class TrackerDataController: NSObject {
    var trackerStore: TrackerStoreProtocol
    var trackerCategoryStore: TrackerCategoryStoreProtocol
    var trackerRecordStore: TrackerRecordStoreProtocol
    var fetchResultController: NSFetchedResultsController<TrackerCoreData>?

    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    private var movedIndexes: [TrackerCategoryStoreUpdate.Move]?

    private var context: NSManagedObjectContext

    weak var delegate: TrackerDataControllerDelegate?

    init(trackerStore: TrackerStoreProtocol, trackerCategoryStore: TrackerCategoryStoreProtocol, trackerRecordStore: TrackerRecordStore, context: NSManagedObjectContext) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.context = context

        super.init()

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchResultController = controller
        try? controller.performFetch()
    }
}

// MARK: - TrackerDataControllerCategoriesProtocol
extension TrackerDataController: TrackerDataControllerCategoriesProtocol {
    var categories: [TrackerCategory] {
        guard let objects = self.fetchResultController?.fetchedObjects else { return [] }
        var trackerCategories = trackerCategoryStore.convertTrackerCoreDataToTrackerCategories(objects)
        trackerCategories.sort(by: { $0.name < $1.name })
        return trackerCategories
    }

    func fetchSearchedCategories(textToSearch: String, weekday: Int) {
        let weekdayPredicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        let textPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), textToSearch)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [weekdayPredicate, textPredicate])
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort(by: { $0.name < $1.name })
        delegate?.updateView(categories: trackerCategories, animating: true, withDateChange: false)
    }

    func fetchCategoriesFor(weekday: Int, animating: Bool) {
        let predicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort(by: { $0.name < $1.name })
        delegate?.updateView(categories: trackerCategories, animating: animating, withDateChange: true)
    }

    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        try trackerCategoryStore.addTrackerCategory(trackerCategory)
    }

    func addNewCategory(_ category: String) throws {
        try trackerCategoryStore.addNewCategory(category)
    }

    func fetchCategoriesList() -> [String] {
        let categories = trackerCategoryStore.fetchAllCategories().map { $0.name }
        return categories
    }

    func updateTrackerProperties(_ tracker: Tracker) throws {
        try trackerStore.updateTrackerProperties(for: tracker)
    }

    func deleteTracker(_ trackerID: String) throws {
        try trackerStore.deleteTracker(trackerID)
    }
}

// MARK: - TrackerDataControllerRecordsProtocol
extension TrackerDataController: TrackerDataControllerRecordsProtocol {
    func fetchRecordsCountForId(_ id: String) -> Int {
        trackerRecordStore.fetchRecordsCountForId(id)
    }

    func checkTrackerRecordExist(id: String, date: String) -> Bool {
        trackerRecordStore.checkTrackerRecordExist(id: id, date: date)
    }

    func addTrackerRecord(id: String, date: String) throws {
        try trackerRecordStore.addTrackerRecord(id: id, date: date)
    }

    func deleteTrackerRecord(id: String, date: String) throws {
        try trackerRecordStore.deleteTrackerRecord(id: id, date: date)
    }

    func fetchRecordsCount() -> Int? {
        return trackerRecordStore.fetchRecordsCount()
    }

    func deleteRecords(for id: String) throws {
        try trackerRecordStore.deleteRecords(for: id)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let insertedIndexes, let deletedIndexes, let updatedIndexes, let movedIndexes else { return }
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes,
            movedIndexes: movedIndexes
        )
        delegate?.updateViewByController(update)

        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath {
                insertedIndexes?.append(newIndexPath)
            }
        case .delete:
            if let indexPath {
                deletedIndexes?.append(indexPath)
            }
        case .move:
            if let newIndexPath, let indexPath {
                movedIndexes?.append(.init(oldIndex: indexPath, newIndex: newIndexPath))
            }
        case .update:
            if let indexPath {
                updatedIndexes?.append(indexPath)
            }
        @unknown default:
            break
        }
    }
}
