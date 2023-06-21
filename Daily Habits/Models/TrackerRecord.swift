//
//  TrackerRecord.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let timestamp: TimeInterval
}

extension TrackerRecord: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
