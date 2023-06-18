//
//  UIColor+Extension.swift
//  Daily Habits
//
//  Created by Вадим Кузьмин on 19.06.2023.
//

import UIKit

extension UIColor {
    static var ypBackground: UIColor {
        UIColor(named: "Background") ?? UIColor.systemBackground
    }

    static var ypBlack: UIColor {
        UIColor(named: "Black") ?? UIColor.black
    }

    static var ypBlue: UIColor{
        UIColor(named: "Blue") ?? UIColor.blue
    }

    static var ypGray: UIColor {
        UIColor(named: "Gray") ?? UIColor.gray
    }

    static var ypLightGray: UIColor {
        UIColor(named: "LightGray") ?? UIColor.lightGray
    }

    static var ypRed: UIColor {
        UIColor(named: "Red") ?? UIColor.red
    }

    static var ypWhite: UIColor {
        UIColor(named: "White") ?? UIColor.white
    }
}
