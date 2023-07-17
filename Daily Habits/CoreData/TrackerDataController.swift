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
    func updateView(categories: [TrackerCategory], animating: Bool)
}

protocol TrackerDataControllerProtocol: AnyObject {
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func fetchCategoriesFor(weekday: Int, animating: Bool)
    func fetchSearchedCategories(textToSearch: String, weekday: Int)

    func fetchRecordsCountForId(_ id: UUID) -> Int
    func checkTrackerRecordExist(id: UUID, date: String) -> Bool
    func addTrackerRecord(id: UUID, date: String)
    func deleteTrackerRecord(id: UUID, date: String)

    var categories: [TrackerCategory] { get }
    var delegate: TrackerDataControllerDelegate? { get set }
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

// MARK: - TrackerDataControllerProtocol
extension TrackerDataController: TrackerDataControllerProtocol {
    func fetchSearchedCategories(textToSearch: String, weekday: Int) {
        let weekdayPredicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        let textPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.name), textToSearch)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [weekdayPredicate, textPredicate])
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort(by: { $0.name < $1.name })
        delegate?.updateView(categories: trackerCategories, animating: true)
    }

    func fetchCategoriesFor(weekday: Int, animating: Bool) {
        let predicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        var trackerCategories = trackerCategoryStore.fetchCategoriesWithPredicate(predicate)
        trackerCategories.sort(by: { $0.name < $1.name })
        delegate?.updateView(categories: trackerCategories, animating: animating)
    }

    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        try? trackerCategoryStore.addTrackerCategory(trackerCategory)
    }

    func fetchRecordsCountForId(_ id: UUID) -> Int {
        return trackerRecordStore.fetchRecordsCountForId(id)
    }

    func checkTrackerRecordExist(id: UUID, date: String) -> Bool {
        return trackerRecordStore.checkTrackerRecordExist(id: id, date: date)
    }

    func addTrackerRecord(id: UUID, date: String) {
        trackerRecordStore.addTrackerRecord(id: id, date: date)
    }

    func deleteTrackerRecord(id: UUID, date: String) {
        trackerRecordStore.deleteTrackerRecord(id: id, date: date)
    }

    var categories: [TrackerCategory] {
        guard let objects = self.fetchResultController?.fetchedObjects else { return [] }
        var trackerCategories = trackerCategoryStore.convertTrackerCoreDataToTrackerCategories(objects)
        trackerCategories.sort(by: { $0.name < $1.name })
        return trackerCategories
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
