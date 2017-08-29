//
//  UIImageView-SDK.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 18/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIImageView {
    func applyBundleImage(name: String, replaceColor: UIColor? = nil) -> Void  {
        if let bundlePath: String = Bundle.main.path(forResource: "FooyoSDK", ofType: "bundle") {
            if let bundle = Bundle(path: bundlePath) {
                let resource: String = bundle.path(forResource: name, ofType: "png")!
                if let color = replaceColor {
                    self.image = UIImage(contentsOfFile: resource)?.imageByReplacingContentWithColor(color: color)
                } else {
                    self.image = UIImage(contentsOfFile: resource)
                }
                return
            }
        }
    }
}
