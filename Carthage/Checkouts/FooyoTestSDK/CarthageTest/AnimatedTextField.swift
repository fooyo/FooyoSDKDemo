//
//  AnimatedTextField.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 17/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class AnimatedTextField: UITextField {
    override var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set(value) {
            placeholderLabel.text = value
        }
    }
    
    let placeholderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeholderEditingDidBeginAnimation() {
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//            s.placeholderLabel.frame.origin.x = s.frame.width - s.placeholderLabel.frame.width// - s.textInset
//            s.placeholderLabel.frame.origin.y = -s.placeholderLabel.frame.height + s.placeholderVerticalOffset
        })
    }
    
}
