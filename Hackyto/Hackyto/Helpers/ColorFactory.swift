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
        return UIColor.whiteColor()
    }

    class func blueColor() -> UIColor {
        return UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
    }
}
