//
//  StatisticViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 09.08.2023.
//

import Foundation

class StatisticViewModel {
    @Observable private(set) var recordsCounterLabel: Int?

    private let dataController: TrackerDataControllerRecordsProtocol

    init(dataController: TrackerDataControllerRecordsProtocol) {
        self.dataController = dataController
    }

    func getStatisticInfo() {
        recordsCounterLabel = dataController.fetchRecordsCount()
    }
}
