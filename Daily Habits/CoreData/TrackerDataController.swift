//
//  TrackerDataController.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 11.07.2023.
//

import Foundation
import CoreData

protocol TrackerDataControllerDelegate: AnyObject {
    func updateView(_ update: TrackerCategoryStoreUpdate)
}

protocol TrackerDataControllerProtocol: AnyObject {
    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws
    func fetchCategoriesFor(weekday: Int)
    var categories: [TrackerCategory] { get }
    var delegate: TrackerDataControllerDelegate? { get set }
}

final class TrackerDataController: NSObject {

    var trackerStore: TrackerStore
    var trackerCategoryStore: TrackerCategoryStore
    var trackerRecordStore: TrackerRecordStore

    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    private var movedIndexes: [TrackerCategoryStoreUpdate.Move]?

    private var context: NSManagedObjectContext
    private var fetchResultController: NSFetchedResultsController<TrackerCategoryCoreData>?


    weak var delegate: TrackerDataControllerDelegate?

    init(trackerStore: TrackerStore, trackerCategoryStore: TrackerCategoryStore, trackerRecordStore: TrackerRecordStore, context: NSManagedObjectContext) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        self.context = context

        super.init()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
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
    func fetchCategoriesFor(weekday: Int) {
        trackerCategoryStore.fetchCategoriesFor(weekday: weekday)
        try? fetchResultController?.performFetch()
    }

    func addTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        print("2. Will call trackerCategoryStore.addTrackerCategory")
        try? trackerCategoryStore.addTrackerCategory(trackerCategory)
    }

    var categories: [TrackerCategory] {
        guard let objects = self.fetchResultController?.fetchedObjects,
              let categories = try? trackerCategoryStore.convertTrackerCategoryCoreDataToTrackerCategory(objects)
        else {
            return []
        }
        return categories
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerDataController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("4. Will call controllerWillChangeContent")
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("5. Will call controllerDidChangeContent")
        guard let insertedIndexes, let deletedIndexes, let updatedIndexes, let movedIndexes else { return }
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes,
            movedIndexes: movedIndexes
        )
        print("6. Will call delegate?.updateView")
        delegate?.updateView(update)

        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Type:", type.rawValue)
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
