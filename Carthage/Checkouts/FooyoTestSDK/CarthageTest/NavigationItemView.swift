//
//  NavigationItemView.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 16/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class NavigationItemView: UIView {

    fileprivate var iconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.backgroundColor = .clear
        return t
    }()
    
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.layer.cornerRadius = 5
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11))
        t.textAlignment = .center
        t.clipsToBounds = true
        t.textColor = .white
        return t
    }()
    
    fileprivate var arrowImage: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "navigation_rightarrow")
        t.contentMode = .scaleAspectFit
        return t
    }()
    
    init(type: FooyoConstants.TransportationType) {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(arrowImage)
        nameLabel.text = type.rawValue
        switch type {
        case .BusA:
            iconView.applyBundleImage(name: "navigation_smallbus")
            nameLabel.backgroundColor = UIColor.busA
        case .BusB:
            iconView.applyBundleImage(name: "navigation_smallbus")
            nameLabel.backgroundColor = UIColor.busB
        case .Express:
            iconView.applyBundleImage(name: "navigation_smalltrain")
            nameLabel.backgroundColor = UIColor.express
        case .Tram:
            iconView.applyBundleImage(name: "navigation_smalltram")
            nameLabel.backgroundColor = UIColor.tram
        case .Foot:
            iconView.applyBundleImage(name: "navigation_smallwalk")
            nameLabel.backgroundColor = UIColor.walk
        case .Drive:
            iconView.applyBundleImage(name: "navigation_smallwalk")
            nameLabel.backgroundColor = UIColor.drive
        default:
            break
        }
        iconView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 12))
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconView.snp.trailing).offset(Scale.scaleX(x: 7))
            make.centerY.equalToSuperview()
            make.width.equalTo(Scale.scaleX(x: 54))
            make.height.equalTo(Scale.scaleY(y: 20))
        }
        arrowImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 5))
            make.width.equalTo(Scale.scaleX(x: 6))
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
