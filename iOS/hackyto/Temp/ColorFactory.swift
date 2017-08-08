//
//  ColorFactory.swift
//  Hackyto
//
//  Created by Ernesto Torres on 12/21/15.
//  Copyright © 2015 ehtd. All rights reserved.
//

import UIKit

class ColorFactory: NSObject {

    class func darkColor() -> UIColor {
        return UIColor(red: 22/255.0, green: 22/255.0, blue: 23/255.0, alpha: 1.0)
    }

    class func darkGrayColor() -> UIColor {
        return UIColor(red: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
    }

    class func lightColor() -> UIColor {
        return UIColor.white
    }

    class func blueColor() -> UIColor {
        return UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
    }

    class func turquoiseColor() -> UIColor {
        return UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1.0)
    }

    class func emeraldColor() -> UIColor {
        return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    }

    class func amethystColor() -> UIColor {
        return UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
    }

    class func sunFlowerColor() -> UIColor {
        return UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
    }

    class func carrotColor() -> UIColor {
        return UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
    }

    class func alizarinColor() -> UIColor {
        return UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
    }

    class func wisteriaColor() -> UIColor {
        return UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    }

    class func orangeColor() -> UIColor {
        return UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1.0)
    }

    class func pumpkinColor() -> UIColor {
        return UIColor(red: 211/255, green: 84/255, blue: 0/255, alpha: 1.0)
    }

    class func belizeHoleColor() -> UIColor {
        return UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
    }

    class func colorFromNumber(_ number: Int) -> UIColor {
        let colors = [
            belizeHoleColor(),
            turquoiseColor(),
            orangeColor(),
            alizarinColor(),
            emeraldColor(),
            sunFlowerColor(),
            amethystColor(),
            carrotColor(),
            pumpkinColor(),
            wisteriaColor()
            ]

        let index = number % 10
        return colors[index]
    }
}
