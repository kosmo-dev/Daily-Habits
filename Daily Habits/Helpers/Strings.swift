//
//  Strings.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 03.08.2023.
//

import Foundation

struct S {
    struct OnboardingViewController {
        static let firstViewControllerText = NSLocalizedString("OnboardingViewControllerFirstViewControllerText", comment: "")
        static let secondViewControllerText = NSLocalizedString("OnboardingViewControllerSecondViewControllerText", comment: "")
        static let button = NSLocalizedString("OnboardingViewControllerButton", comment: "")
    }

    struct TabBarController {
        static let trackersTabBarItem = NSLocalizedString("TabBarControllerTrackersTabBarItem", comment: "")
        static let statisticsTabBarItem = NSLocalizedString("TabBarControllerStatisticsTabBarItem", comment: "")
    }

    struct TrackersViewController {
        static let searchPlaceholder = NSLocalizedString("TrackersViewControllerSearchPlaceholder", comment: "")
        static let emptyTrackersPlaceholder = NSLocalizedString("TrackersViewControllerEmptyTrackersPlaceholder", comment: "")
        static let notFoundPlaceholder = NSLocalizedString("TrackersViewControllerNotFoundPlaceholder", comment: "")
        static let navigationTitle = NSLocalizedString("TrackersViewControllerNavigationTitle", comment: "")
        static let alertControllerTitle = NSLocalizedString("TrackersViewControllerAlertControllerTitle", comment: "")
        static let alertControllerAction = NSLocalizedString("TrackersViewControllerAlertControllerAction", comment: "")
        static let alertControllerErrorAddingTracker = NSLocalizedString("TrackersViewControllerAlertControllerErrorAddingTracker", comment: "")
    }

    struct NewTrackerTypeChoosingViewController {
        static let habitButton = NSLocalizedString("NewTrackerTypeChoosingViewControllerHabitButton", comment: "")
        static let eventButton = NSLocalizedString("NewTrackerTypeChoosingViewControllerEventButton", comment: "")
        static let navigationTitle = NSLocalizedString("NewTrackerTypeChoosingViewControllerNavigationTitle", comment: "")
    }

    struct NewTrackerViewController {
        static let titleTextFieldPlaceholder = NSLocalizedString("NewTrackerViewControllerTitleTextFieldPlaceholder", comment: "")
        static let emojiTitle = NSLocalizedString("NewTrackerViewControllerEmojiTitle", comment: "")
        static let colorsTitle = NSLocalizedString("NewTrackerViewControllerColorsTitle", comment: "")
        static let createButton = NSLocalizedString("NewTrackerViewControllerCreateButton", comment: "")
        static let navigationTitle = NSLocalizedString("NewTrackerViewControllerNavigationTitle", comment: "")
        static let categoryHeader = NSLocalizedString("NewTrackerViewControllerCategoryHeader", comment: "")
        static let scheduleHeader = NSLocalizedString("NewTrackerViewControllerScheduleHeader", comment: "")
        static let scheduleEveryDaySecondaryText = NSLocalizedString("NewTrackerViewControllerScheduleEveryDaySecondaryText", comment: "")
    }

    struct CategoryViewController {
        static let addCategoryButton = NSLocalizedString("CategoryViewControllerAddCategoryButton", comment: "")
        static let alertControllerErrorCategoryExist = NSLocalizedString("CategoryViewControllerAlertControllerErrorCategoryExist", comment: "")
    }

    struct NewCategoryViewController {
        static let textFieldPlaceholder = NSLocalizedString("NewCategoryViewControllerTextFieldPlaceholder", comment: "")
        static let navigationTitle = NSLocalizedString("NewCategoryViewControllerNavigationTitle", comment: "")
    }

    struct ScheduleViewController {
        static let confirmButton = NSLocalizedString("ScheduleViewControllerConfirmButton", comment: "")
    }

    static let cancelButton = NSLocalizedString("CancelButton", comment: "")
}
