//
//  TrackerRecordStore.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 07.07.2023.
//

import Foundation
import CoreData

protocol TrackerRecordStoreProtocol {
    func fetchRecordsCountForId(_ id: UUID) -> Int
    func checkTrackerRecordExist(id: UUID, date: String) -> Bool
    func addTrackerRecord(id: UUID, date: String)
    func deleteTrackerRecord(id: UUID, date: String)
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
//        super.init()
    }
}

// MARK: - TrackerRecordStoreProtocol
extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func addTrackerRecord(id: UUID, date: String) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.trackerID = id.uuidString
        newTrackerRecord.date = date
        do {
            try context.save()
        } catch {
            print("Error save trackerRecord")
        }
    }

    func deleteTrackerRecord(id: UUID, date: String) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        do {
            if let trackerRecord = try context.fetch(request).first {
                context.delete(trackerRecord)
                try context.save()
            }
        } catch {
            print("Error delete trackerRecord")
        }
    }

    func fetchRecordsCountForId(_ id: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            return 0
        }
    }

    func checkTrackerRecordExist(id: UUID, date: String) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        do {
            let count = try context.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
