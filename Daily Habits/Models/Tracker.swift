//
//  Tracker.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import UIKit

struct Tracker {
    let id: String
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Int]
    var isPinned: Bool
}
