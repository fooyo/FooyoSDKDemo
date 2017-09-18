//
//  CategoryTableViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 11/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "categoryTableViewCell"
    fileprivate var iconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    
    fileprivate var rightIconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        return t
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        backgroundColor = .clear
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightIconView)
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        //        fakeItem.addGestureRecognizer(gesture)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 14))
            make.width.height.equalTo(Scale.scaleY(y: 20))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(Scale.scaleX(x: 10))
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 16))
            make.trailing.equalTo(Scale.scaleX(x: -14))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(leftIcon: Any? = nil, title: String?, rightIcon: UIImage? = nil, boldTitle: Bool = false) {
        if let image = leftIcon as? UIImage {
            iconView.image = image
        } else if let url = leftIcon as? String {
            let width = Scale.scaleY(y: 20)
            let height = Scale.scaleY(y: 20)
            let size = CGSize(width: width, height: height)
            iconView.af_setImage(
                withURL: NSURL(string: url)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFitSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        } else {
            iconView.image = nil
        }
        if let image = rightIcon {
            rightIconView.image = rightIcon
        } else {
            rightIconView.image = nil
        }
        titleLabel.text = title
        if boldTitle {
            titleLabel.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
            titleLabel.textColor = UIColor.ospIoSblue
        } else {
            titleLabel.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
            titleLabel.textColor = UIColor.ospDarkGrey

        }
    }

}
