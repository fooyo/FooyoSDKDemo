//
//  UIColor-SS.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 17/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(rgb: Int) {
//        self.init(
//            red: (rgb >> 16) & 0xFF,
//            green: (rgb >> 8) & 0xFF,
//            blue: rgb & 0xFF
//        )
//    }
    convenience init(hexString:String) {
//        hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let hexString:NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

extension UIColor {
    class var ospSentosaBlue: UIColor {
        return UIColor(red: 0.0, green: 174.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
    }
    
    class var ospFacebookBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    class var ospGrey: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 164.0 / 255.0, blue: 175.0 / 255.0, alpha: 1.0)
    }
    
    class var ospWhite: UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 1.0)
    }
    class var ospBlack: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    class var ospSentosaOrange: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 125.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var ospGrey50: UIColor {
        return UIColor(red: 191.0 / 255.0, green: 206.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.5)
    }
    
    class var ospSentosaPink: UIColor {
        return UIColor(red: 236.0 / 255.0, green: 0.0, blue: 140.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPurple: UIColor {
        return UIColor(red: 124.0 / 255.0, green: 81.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
    }
    
    class var ospDarkGrey: UIColor {
        return UIColor(red: 86.0 / 255.0, green: 100.0 / 255.0, blue: 106.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaBlueLightest: UIColor {
        return UIColor(red: 109.0 / 255.0, green: 207.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    class var ospGrey20: UIColor {
        return UIColor(red: 191.0 / 255.0, green: 206.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.2)
    }
    
    class var ospSentosaGreenLight: UIColor {
        return UIColor(red: 126.0 / 255.0, green: 195.0 / 255.0, blue: 82.0 / 255.0, alpha: 1.0)
    }
    
    class var ospWhite50: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 0.5)
    }
    
    class var ospSentosaRed10: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 0.1)
    }
    
    class var ospSentosaRedDark: UIColor {
        return UIColor(red: 187.0 / 255.0, green: 19.0 / 255.0, blue: 26.0 / 255.0, alpha: 1.0)
    }
    
    class var ospOverlay: UIColor {
        return UIColor(white: 0.0, alpha: 0.4)
    }
    
    class var ospIoSblue: UIColor {
        return UIColor(red: 0.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaBlue20: UIColor {
        return UIColor(red: 0.0, green: 174.0 / 255.0, blue: 239.0 / 255.0, alpha: 0.2)
    }
    
    class var ospSentosaYellowDark: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 194.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaRed: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaBlueDarkest: UIColor {
        return UIColor(red: 0.0, green: 111.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPurpleDark: UIColor {
        return UIColor(red: 92.0 / 255.0, green: 45.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaRedLightest: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 91.0 / 255.0, blue: 103.0 / 255.0, alpha: 1.0)
    }
    
    class var ospGrey10: UIColor {
        return UIColor(red: 191.0 / 255.0, green: 206.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.1)
    }
    
    class var ospSentosaPurpleLightest: UIColor {
        return UIColor(red: 168.0 / 255.0, green: 128.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    }
    
    class var ospDropShadow35: UIColor {
        return UIColor(white: 0.0, alpha: 0.35)
    }
    
    class var ospSentosaGreen50: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 184.0 / 255.0, blue: 72.0 / 255.0, alpha: 0.5)
    }
    
    class var ospSentosaBlueLight: UIColor {
        return UIColor(red: 0.0, green: 189.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaGreenDarkest: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 117.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaGreenDark: UIColor {
        return UIColor(red: 60.0 / 255.0, green: 147.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaGreenLightest: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 207.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaBlueDark: UIColor {
        return UIColor(red: 0.0, green: 139.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPurpleDarkest: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 4.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPurpleLight: UIColor {
        return UIColor(red: 150.0 / 255.0, green: 101.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaRedDarkest: UIColor {
        return UIColor(red: 139.0 / 255.0, green: 3.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaRedLight: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 22.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPeachDarkest: UIColor {
        return UIColor(red: 183.0 / 255.0, green: 105.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPeachDark: UIColor {
        return UIColor(red: 212.0 / 255.0, green: 127.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPeach: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 151.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPeachLight: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 180.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPeachLightest: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 201.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaYellowDarkest: UIColor {
        return UIColor(red: 220.0 / 255.0, green: 169.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaYellow: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 242.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var ospSentosaYellowLight: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 244.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaYellowLightest: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 247.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPinkDarkest: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 0.0, blue: 82.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPinkDark: UIColor {
        return UIColor(red: 186.0 / 255.0, green: 0.0, blue: 111.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPinkLight: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 103.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaPinkLightest: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 154.0 / 255.0, blue: 193.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaDarkGrey: UIColor { 
        return UIColor(white: 86.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaGrey: UIColor { 
        return UIColor(white: 170.0 / 255.0, alpha: 1.0)
    }
    
    class var ospGrabGreen: UIColor {
        return UIColor(red: 0.0, green: 159.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    class var ospSentosaGreen: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 184.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
    }
    
    class var ospBlack20: UIColor { 
        return UIColor(white: 0.0, alpha: 0.2)
    }

    
}
