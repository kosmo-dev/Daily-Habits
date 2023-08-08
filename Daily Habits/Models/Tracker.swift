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
    var category: String
}

extension Tracker {
    var colorIndex: Int? {
        C.Colors.hexColors.firstIndex(of: color.hexString())
    }

    var emojiIndex: Int? {
        C.Emojis.emojis.firstIndex(of: emoji)
    }
}
