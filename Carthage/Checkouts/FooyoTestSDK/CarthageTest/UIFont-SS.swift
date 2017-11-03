//
//  UIFont.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 17/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIFont {
    class func DefaultRegularWithSize(size: CGFloat) -> UIFont {
                return UIFont(name: "Quicksand-Regular", size: size)!
//        return UIFont.systemFont(ofSize: size)
    }
    class func DefaultSemiBoldWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Medium", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
    }
    class func DefaultBoldWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Quicksand-Bold", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
    }
}
