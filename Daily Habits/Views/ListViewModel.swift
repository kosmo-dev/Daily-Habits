//
//  ListViewModel.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 22.07.2023.
//

import UIKit

struct ListViewModel {
    let maskedCorners: CACornerMask
    let bottomDividerIsHidden: Bool
    let primaryText: String
    let type: ListView.ViewType
    let action: Selector?
    let switcherIsOn: Bool?
}
