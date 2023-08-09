//
//  TrackerRecordStore.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 07.07.2023.
//

import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func fetchRecordsCountForId(_ id: String) -> Int
    func checkTrackerRecordExist(id: String, date: String) -> Bool
    func addTrackerRecord(id: String, date: String) throws
    func deleteTrackerRecord(id: String, date: String) throws
    func fetchRecordsCount() -> Int?
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

// MARK: - TrackerRecordStoreProtocol
extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func addTrackerRecord(id: String, date: String) throws {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.trackerID = id
        newTrackerRecord.date = date
        try context.save()
    }

    func deleteTrackerRecord(id: String, date: String) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: C.CoreDataEntityNames.trackerRecordCoreData)
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        if let trackerRecord = try context.fetch(request).first {
            context.delete(trackerRecord)
            try context.save()
        }
    }

    func fetchRecordsCountForId(_ id: String) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: C.CoreDataEntityNames.trackerRecordCoreData)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id)
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }

    func checkTrackerRecordExist(id: String, date: String) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: C.CoreDataEntityNames.trackerRecordCoreData)
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }

    func fetchRecordsCount() -> Int? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: C.CoreDataEntityNames.trackerRecordCoreData)
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
}
