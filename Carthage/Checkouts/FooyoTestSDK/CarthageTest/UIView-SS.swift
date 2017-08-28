//
//  UIView-ss.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 18/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit


extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        debugPrint(self.bounds)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
