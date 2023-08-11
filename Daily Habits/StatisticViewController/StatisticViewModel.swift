//
//  StatisticViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 09.08.2023.
//

import Foundation

protocol StatisticViewModelProtocol {
    var internalDataSource: [DataSource] { get }
    func setBindings(action: @escaping ([DataSource]) -> ())
    func getStatisticInfo()
}

struct DataSource {
    let counter: Int
    let description: String
}

final class StatisticViewModel: StatisticViewModelProtocol {
    var internalDataSource: [DataSource] {
        $dataSource.wrappedValue
    }

    @Observable private(set) var dataSource: [DataSource] = []

    private let dataController: TrackerDataControllerRecordsProtocol

    init(dataController: TrackerDataControllerRecordsProtocol) {
        self.dataController = dataController
    }

    func getStatisticInfo() {
        dataSource.removeAll()
        guard let firstCounter = dataController.fetchRecordsCount() else { return }
        let firstDescription = S.StatisticViewController.finishedTrackers
        if firstCounter != 0 {
            dataSource.append(DataSource(counter: firstCounter, description: firstDescription))
        }
    }

    func setBindings(action: @escaping ([DataSource]) -> ()) {
        $dataSource.bind { data in
            action(data)
        }
    }
}
