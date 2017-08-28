//
//  FeatureInputTableViewCell.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 27/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class FeatureInputTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FeatureInputTableViewCell"
    
    var inputField: UITextField! = {
        let t = UITextField()
//        t.layer.borderWidth = 1
//        t.layer.borderColor = UIColor.black.cgColor
        t.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 1))
        t.leftViewMode = .always
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.layer.borderWidth = 1
//        t.backgroundColor = UIColor.lightGray
        t.layer.cornerRadius = 4
        t.clipsToBounds = true
        t.textColor = UIColor.darkGray
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        layoutMargins = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
        selectionStyle = .none
        clipsToBounds = true
        contentView.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(35)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(title: String, placeHold: String, isCompulsory: Bool? = nil) {
        textLabel?.text = title
        textLabel?.textColor = UIColor.gray
        inputField.placeholder = placeHold
        
        if let isCompulsory = isCompulsory {
            if isCompulsory {
                detailTextLabel?.text = "(Compulsory)"
            } else {
                detailTextLabel?.text = "(Optional)"
            }
        } else {
            detailTextLabel?.text = nil
        }
    }

}
