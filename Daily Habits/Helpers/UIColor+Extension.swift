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

    static var colorSelection1: UIColor {
        UIColor(named: "Color Selection 1") ?? UIColor.green
    }
    static var colorSelection2: UIColor {
        UIColor(named: "Color Selection 2") ?? UIColor.green
    }
    static var colorSelection3: UIColor {
        UIColor(named: "Color Selection 3") ?? UIColor.green
    }
    static var colorSelection4: UIColor {
        UIColor(named: "Color Selection 4") ?? UIColor.green
    }
    static var colorSelection5: UIColor {
        UIColor(named: "Color Selection 5") ?? UIColor.green
    }
    static var colorSelection6: UIColor {
        UIColor(named: "Color Selection 6") ?? UIColor.green
    }
    static var colorSelection7: UIColor {
        UIColor(named: "Color Selection 7") ?? UIColor.green
    }
    static var colorSelection8: UIColor {
        UIColor(named: "Color Selection 8") ?? UIColor.green
    }
    static var colorSelection9: UIColor {
        UIColor(named: "Color Selection 9") ?? UIColor.green
    }
    static var colorSelection10: UIColor {
        UIColor(named: "Color Selection 10") ?? UIColor.green
    }
    static var colorSelection11: UIColor {
        UIColor(named: "Color Selection 11") ?? UIColor.green
    }
    static var colorSelection12: UIColor {
        UIColor(named: "Color Selection 12") ?? UIColor.green
    }
    static var colorSelection13: UIColor {
        UIColor(named: "Color Selection 13") ?? UIColor.green
    }
    static var colorSelection14: UIColor {
        UIColor(named: "Color Selection 14") ?? UIColor.green
    }
    static var colorSelection15: UIColor {
        UIColor(named: "Color Selection 15") ?? UIColor.green
    }
    static var colorSelection16: UIColor {
        UIColor(named: "Color Selection 16") ?? UIColor.green
    }
    static var colorSelection17: UIColor {
        UIColor(named: "Color Selection 17") ?? UIColor.green
    }
    static var colorSelection18: UIColor {
        UIColor(named: "Color Selection 18") ?? UIColor.green
    }

    func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }

    static func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
