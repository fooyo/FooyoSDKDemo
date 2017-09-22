//
//  ItemSummaryTableViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 12/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemSummaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ItemSummaryTableViewCell"
    fileprivate var separatorView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    fileprivate var container: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        return t
    }()
    fileprivate var iconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        t.layer.cornerRadius = 4
        t.backgroundColor = UIColor.ospWhite
        return t
    }()
    
    fileprivate var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    
    fileprivate var rightIconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
//        backgroundColor = .clear
        contentView.backgroundColor = UIColor.white//.withAlphaComponent(0.9)
        contentView.addSubview(separatorView)
        contentView.addSubview(container)
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(rightIconView)
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        //        fakeItem.addGestureRecognizer(gesture)
        
        separatorView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 10))
        }
        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(separatorView.snp.top)
            make.top.equalToSuperview()
        }
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.width.height.equalTo(Scale.scaleY(y: 39))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(Scale.scaleX(x: 10))
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 12))
            make.trailing.equalTo(Scale.scaleX(x: -18))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(item: FooyoItem, rightImage: UIImage? = nil) {
        titleLabel.text = item.name
        if let url = item.coverImages {
            let width = Scale.scaleY(y: 39)
            let height = Scale.scaleY(y: 39)
            let size = CGSize(width: width, height: height)
            iconView.af_setImage(
                withURL: NSURL(string: url)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        rightIconView.image = rightImage
    }

}
