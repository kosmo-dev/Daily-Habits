//
//  TrackersCollectionViewUpdate.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 27.07.2023.
//

import Foundation

struct TrackersCollectionViewUpdate {
    let insertedIndexes: [IndexPath]
    let removedIndexes: [IndexPath]
    let reloadedIndexes: [IndexPath]
    let insertedSections: IndexSet
    let removedSections: IndexSet

    init(insertedIndexesInSearch: [IndexPath], removedIndexesInSearch: [IndexPath], reloadedIndexes: [IndexPath], insertedSectionsInSearch: IndexSet, removedSectionsInSearch: IndexSet) {
        self.insertedIndexes = insertedIndexesInSearch
        self.removedIndexes = removedIndexesInSearch
        self.reloadedIndexes = reloadedIndexes
        self.insertedSections = insertedSectionsInSearch
        self.removedSections = removedSectionsInSearch
    }

    init() {
        insertedIndexes = []
        removedIndexes = []
        reloadedIndexes = []
        insertedSections = []
        removedSections = []
    }
}
