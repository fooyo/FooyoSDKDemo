//
//  EmptyTableViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 13/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    static let reuseIdentifier = "emptyTableViewCell"
    
    var overlay: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    var emptyLabel: UILabel! = {
        let t = UILabel(frame: CGRect.zero)
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.darkGray
        t.textAlignment = .center
        t.numberOfLines = 0
        t.lineBreakMode = .byWordWrapping
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(overlay)
        contentView.addSubview(emptyLabel)
        clipsToBounds = true
        overlay.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(Scale.scaleY(y: 174))
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(_ message: String) {
        emptyLabel.text = message
    }
}
