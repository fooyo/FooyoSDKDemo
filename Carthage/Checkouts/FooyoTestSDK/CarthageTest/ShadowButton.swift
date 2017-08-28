//
//  ShadowButton.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 22/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowColor = UIColor.ospBlack20.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
        self.layer.shadowRadius = Scale.scaleY(y: 4)
        self.layer.shadowOpacity = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
