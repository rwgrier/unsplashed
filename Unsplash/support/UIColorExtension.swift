//
//  UIColorExtension.swift
//  Unsplash
//
//  Created by Ryan Grier on 7/18/16.
//  Copyright © 2016 Ryan Grier. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespaces).uppercased()

        if cleanHex.hasPrefix("#") {
            cleanHex = String(cleanHex[cleanHex.index(cleanHex.startIndex, offsetBy: 1)...])
        }

        guard cleanHex.count == 6 else {
            self.init(red: 255.0/2, green: 255.0/2, blue: 255.0/2, alpha: 1.0)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
