//
//  FeatureTableViewCell.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 27/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class FeatureTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FeatureTableViewCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        selectionStyle = .none
        clipsToBounds = true
//        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: #imageLiteral(resourceName: "general_rightarrow").imageByReplacingContentWithColor(color: .white))
//        setConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setConstrains() {
//        nameLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 15))
//            make.trailing.equalTo(-Scale.scaleX(x: 15))
//            make.top.equalTo(Scale.scaleY(y: 12.5))
//        }
//        desLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(nameLabel)
//            make.top.equalTo(nameLabel.snp.bottom).offset(Scale.scaleY(y: 11))
//            make.trailing.equalTo(Scale.scaleX(x: -141))
//        }
//    }
    
    func configureWith(name: String, color: UIColor) {
        textLabel?.text = name
        textLabel?.textColor = .white
        contentView.backgroundColor = color
        backgroundColor = color
        detailTextLabel?.textColor = .white
//        self.accessor
    }
}
