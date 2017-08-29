//
//  UIImage-SS.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 17/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

extension UIImage {
    func imageByReplacingContentWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context!.clip(to: rect, mask: self.cgImage!)
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func getBundleImage(name: String, replaceColor: UIColor? = nil) -> UIImage  {
        if let bundlePath: String = Bundle.main.path(forResource: "FooyoSDK", ofType: "bundle") {
            if let bundle = Bundle(path: bundlePath) {
                let resource: String = bundle.path(forResource: name, ofType: "png")!
                if let color = replaceColor {
                    return (UIImage(contentsOfFile: resource)?.imageByReplacingContentWithColor(color: color))!
                } else {
                    return UIImage(contentsOfFile: resource)!
                }
            }
        }
        return UIImage()
    }

    
}
