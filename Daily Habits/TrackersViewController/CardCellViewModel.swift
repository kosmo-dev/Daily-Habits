//
//  CardCellViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 25.06.2023.
//

import Foundation

struct CardCellViewModel {
    let tracker: Tracker
    let counter: Int
    var buttonIsChecked: Bool
    let indexPath: IndexPath
    let buttonIsEnabled: Bool
}
