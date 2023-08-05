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
        static let trackerCoreData = "TrackerCoreData"
    }
}
