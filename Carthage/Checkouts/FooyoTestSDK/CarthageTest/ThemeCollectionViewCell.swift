//
//  ThemeCollectionViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 14/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ThemeCollectionViewCell"

    fileprivate var imageView: UIImageView! = {
        let t = UIImageView()
        t.clipsToBounds = true
        t.layer.cornerRadius = 4
        t.contentMode = .scaleAspectFill
        t.backgroundColor = UIColor.ospWhite
        return t
    }()
    
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    
    fileprivate var selectedIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "plan_choosetheme")
        return t
    }()
    
    fileprivate var selectedView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospSentosaGreen.withAlphaComponent(0.92)
        t.layer.cornerRadius = Scale.scaleY(y: 56) / 2
        return t
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(selectedView)
        selectedView.addSubview(selectedIcon)
        contentView.addSubview(nameLabel)
        selectedView.isHidden = true
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 203))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(Scale.scaleY(y: 12))
            make.bottom.equalToSuperview()
        }
        selectedView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
            make.height.width.equalTo(Scale.scaleY(y: 56))
        }
        selectedIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 27))
            make.width.equalTo(Scale.scaleX(x: 30))
        }
    }
    
    func configureWith(theme: FooyoConstants.ThemeName) {
        nameLabel.text = theme.rawValue
//        switch theme {
//        case .Culture:
//            imageView.applyBundleImage(name: "theme_1_culture_heritage")
//        case .Family:
//            imageView.applyBundleImage(name: "theme_2_family_fun")
//        case .Hip:
//            imageView.applyBundleImage(name: "theme_3_hip_hangouts")
//        case .Nature:
//            imageView.applyBundleImage(name: "theme_4_nature_wildlife")
//        case .Thrill:
//            imageView.applyBundleImage(name: "theme_5_thrills_adventures")
//        default:
//            imageView.applyBundleImage(name: "theme_6_culture_heritage")
//        }
    }
    
    func selected() {
        selectedView.isHidden = false
    }
    
    func deselected() {
        selectedView.isHidden = true
    }
}
