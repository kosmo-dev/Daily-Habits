//
//  StatisticViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 09.08.2023.
//

import Foundation

class StatisticViewModel {
    @Observable private(set) var dataSource: [(counter: Int, description: String)] = []

    private let dataController: TrackerDataControllerRecordsProtocol

    init(dataController: TrackerDataControllerRecordsProtocol) {
        self.dataController = dataController
    }

    func getStatisticInfo() {
        dataSource.removeAll()
        guard let firstCounter = dataController.fetchRecordsCount() else { return }
        let firstDescription = S.StatisticViewController.finishedTrackers
        if firstCounter != 0 {
            dataSource.append((counter: firstCounter, description: firstDescription))
        }
    }
}
