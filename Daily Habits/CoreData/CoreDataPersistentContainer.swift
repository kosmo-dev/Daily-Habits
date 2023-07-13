//
//  CoreDataPersistentContainer.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 11.07.2023.
//

import Foundation
import CoreData

final class CoreDataPersistentContainer {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}
