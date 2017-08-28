//
//  UILabel-SS.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 22/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//
import UIKit

extension UILabel {
    func heightForLabel(_ text:String? = nil, font:UIFont? = nil, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        if let text = text {
            label.text = text
        } else {
            label.text = self.text
        }
        if let font = font {
            label.font = font
        } else {
            label.font = self.font
        }
        label.sizeToFit()
        return label.frame.height
    }
}
