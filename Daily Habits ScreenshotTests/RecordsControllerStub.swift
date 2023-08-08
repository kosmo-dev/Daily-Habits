//
//  RecordsControllerStub.swift
//  Daily Habits ScreenshotTests
//
//  Created by Вадим Кузьмин on 08.08.2023.
//

import Foundation
@testable import Daily_Habits

class RecordsControllerStub: TrackerDataControllerRecordsProtocol {
    func fetchRecordsCountForId(_ id: String) -> Int {
        return 0
    }

    func checkTrackerRecordExist(id: String, date: String) -> Bool {
        return true
    }

    func addTrackerRecord(id: String, date: String) throws {}

    func deleteTrackerRecord(id: String, date: String) throws {}
}
