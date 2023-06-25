//
//  String+Extension.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 24.06.2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

}
