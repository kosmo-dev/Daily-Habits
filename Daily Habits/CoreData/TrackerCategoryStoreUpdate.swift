//
//  TrackerCategoryStoreUpdate.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 12.07.2023.
//

import Foundation

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
    let movedIndexes: [Move]
}
