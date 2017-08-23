//
//  UIColorUtilities.swift
//  hackyto
//
//  Created by Ernesto Torres on 8/22/17.
//  Copyright © 2017 Ernesto Torres. All rights reserved.
//

import UIKit

extension UIColor {
    class func fromInt(intColor: Int) -> UIColor {
        let mask = 0x0000FF
        let red = (CGFloat)((intColor >> 16) & mask)
        let green = (CGFloat)((intColor >> 8) & mask)
        let blue = (CGFloat)(intColor & 0x0000FF)

        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}
