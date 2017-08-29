//
//  FakeTableViewCell.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 28/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class FakeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FakeTableViewCell"
    fileprivate var fakePhoto: UILabel! = {
        let t = UILabel()
        t.layer.cornerRadius = 4
        t.clipsToBounds = true
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    fileprivate var fakeText: UILabel! = {
        let t = UILabel()
        t.layer.cornerRadius = 2
        t.clipsToBounds = true
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    fileprivate var fakeTextTwo: UILabel! = {
        let t = UILabel()
        t.layer.cornerRadius = 2
        t.clipsToBounds = true
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    fileprivate var fakeTextThree: UILabel! = {
        let t = UILabel()
        t.layer.cornerRadius = 2
        t.clipsToBounds = true
        t.backgroundColor = UIColor.ospGrey50
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = .white
        contentView.addSubview(fakePhoto)
        contentView.addSubview(fakeText)
        contentView.addSubview(fakeTextTwo)
        contentView.addSubview(fakeTextThree)
        fakePhoto.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(fakePhoto.snp.height)
        }
        fakeText.snp.makeConstraints { (make) in
            make.top.equalTo(fakePhoto).offset(5)
            make.leading.equalTo(fakePhoto.snp.trailing).offset(5)
            make.trailing.equalTo(-100)
            make.height.equalTo(15)
        }
        fakeTextTwo.snp.makeConstraints { (make) in
            make.top.equalTo(fakeText.snp.bottom).offset(10)
            make.leading.equalTo(fakeText)
            make.trailing.equalTo(-10)
            make.height.equalTo(10)
        }
        fakeTextThree.snp.makeConstraints { (make) in
            make.top.equalTo(fakeTextTwo.snp.bottom).offset(5)
            make.leading.equalTo(fakeText)
            make.trailing.equalTo(-50)
            make.height.equalTo(10)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
