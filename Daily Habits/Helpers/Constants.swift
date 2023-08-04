//
//  Constants.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 21.06.2023.
//

import UIKit

struct C {
    struct Constants {
        static let pinnedHeader = "pinnedHeader"
    }
    struct UIImages {
        static let emptyTrackersPlaceholder = "EmptyTrackersPlaceholder"
        static let searchNotFoundPlaceholder = "SearchNotFoundPlaceholder"
        
        static let onboardingFirst = "Onboarding1"
        static let onboardingSecond = "Onboarding2"
    }

    struct Emojis {
        static let emojis: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    }

    struct Colors {
        static let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18]
    }

    struct CoreDataEntityNames {
        static let trackerCategoryCoreData = "TrackerCategoryCoreData"
        static let trackerRecordCoreData = "TrackerRecordCoreData"
    }

    struct MockCategories {
        static let categories: [TrackerCategory] = [
            TrackerCategory(name: "First", trackers: [
                Tracker(id: UUID(), name: "1", color: .systemRed, emoji: "❤️", schedule: [4]),
                Tracker(id: UUID(), name: "11", color: .systemBlue, emoji: "❤️", schedule: [4]),
                Tracker(id: UUID(), name: "123", color: .systemGray, emoji: "❤️", schedule: [4]),
                Tracker(id: UUID(), name: "2123", color: .systemPink, emoji: "❤️", schedule: [4]),
                Tracker(id: UUID(), name: "234", color: .systemGreen, emoji: "❤️", schedule: [4]),
            ]),
            TrackerCategory(name: "Second", trackers: [
                Tracker(id: UUID(), name: "1123", color: .colorSelection5, emoji: "❤️", schedule: [0, 1, 2, 3, 4, 5, 6, 7]),
                Tracker(id: UUID(), name: "23", color: .systemBrown, emoji: "❤️", schedule: [0, 1, 2, 3, 4, 5, 6, 7]),
                Tracker(id: UUID(), name: "234", color: .systemTeal, emoji: "❤️", schedule: [0, 1, 2, 3, 4, 5, 6, 7]),
                Tracker(id: UUID(), name: "34", color: .systemOrange, emoji: "❤️", schedule: [0, 1, 2, 3, 4, 5, 6, 7]),
                Tracker(id: UUID(), name: "451", color: .ypBlue, emoji: "❤️", schedule: [0, 1, 2, 3, 4, 5, 6, 7]),
            ])
        ]
    }
}
