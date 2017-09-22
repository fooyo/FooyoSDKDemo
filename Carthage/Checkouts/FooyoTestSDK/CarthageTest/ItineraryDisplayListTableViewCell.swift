//
//  ItineraryDisplayListTableViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 2/5/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage
protocol ItineraryDisplayListTableViewCellDelegate: class {
    func didTapRoute(route: FooyoRoute)
}

class ItineraryDisplayListTableViewCell: UITableViewCell {
    static let reuseIdentifier = "itineraryDisplayListTableViewCell"
    weak var delegate: ItineraryDisplayListTableViewCellDelegate?
    
    fileprivate var route: FooyoRoute?

    fileprivate var containerView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey10
        return t
    }()
    fileprivate var numberLabel: UILabel! = {
        let t = UILabel()
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.ospSentosaGreen.cgColor
        t.clipsToBounds = true
        t.layer.cornerRadius = Scale.scaleY(y: 14) / 2
        t.textColor = UIColor.ospSentosaGreen
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11))
        t.textAlignment = .center
        return t
    }()
    fileprivate var lineOne: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    
    fileprivate var lineTwo: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    
    fileprivate var lineThree: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    
    fileprivate var lineFour: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey
        return t
    }()
    
    fileprivate var avatarView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFill
        t.backgroundColor = UIColor.ospWhite
        t.clipsToBounds = true
        return t
    }()

    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    fileprivate var timeLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospSentosaGreen
        return t
    }()
    
    fileprivate var reviewImage: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.backgroundColor = .clear
        t.applyBundleImage(name: "basemap_review")
        return t
    }()
    
    fileprivate var reviewLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospDarkGrey
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11))
        return t
    }()
    
    fileprivate var lowerPart: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey20
        return t
    }()
    fileprivate var transportationIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var transportationLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 11))
        return t
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(lineOne)
        containerView.addSubview(numberLabel)
        containerView.addSubview(lineTwo)
        containerView.addSubview(lineThree)
        containerView.addSubview(lineFour)
        containerView.addSubview(avatarView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(reviewImage)
        containerView.addSubview(reviewLabel)
        contentView.addSubview(lowerPart)
        lowerPart.addSubview(transportationIcon)
        lowerPart.addSubview(transportationLabel)
        setConstraints()
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(navHandler))
//        navView.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func navHandler() {
        delegate?.didTapRoute(route: route!)
    }
    
    func setConstraints() {
        numberLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 14))
            make.leading.equalTo(Scale.scaleX(x: 17))
            make.top.equalTo(Scale.scaleY(y: 17))
        }
        lineOne.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.top.equalToSuperview()
            make.bottom.equalTo(numberLabel.snp.top)
            make.centerX.equalTo(numberLabel)
        }
        lineTwo.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.top.equalTo(numberLabel.snp.bottom)
            make.centerX.equalTo(numberLabel)
            make.bottom.equalTo(lineFour.snp.top)
        }
        lineThree.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalTo(Scale.scaleX(x: 8))
            make.top.equalTo(lineTwo.snp.bottom)
            make.centerX.equalTo(numberLabel)
        }
        lineFour.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 15))
            make.centerX.equalTo(numberLabel)
        }
        avatarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 64))
            make.leading.equalTo(numberLabel.snp.trailing).offset(Scale.scaleX(x: 16))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(Scale.scaleX(x: 14))
            make.top.equalTo(avatarView).offset(Scale.scaleY(y: 4))
            make.trailing.equalTo(Scale.scaleX(x: -14))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
        }
        reviewImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 14.5))
            make.leading.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(Scale.scaleY(y: 8))
        }
        reviewLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewImage)
            make.leading.equalTo(reviewImage.snp.trailing).offset(Scale.scaleX(x: 9))
        }
        containerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(lowerPart.snp.top)
        }
        lowerPart.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 48))
        }
        transportationIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 12))
            make.centerY.equalToSuperview()
            make.centerX.equalTo(numberLabel)
        }
        transportationLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarView)
        }
    }
    
    func configureWith(item: FooyoItem, route: FooyoRoute? = nil, index: Int, isFirst: Bool = false, isLast: Bool = false) {
        if let image = item.coverImages {
            let size = CGSize(width: Scale.scaleY(y: 64), height: Scale.scaleY(y: 64))
            avatarView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        nameLabel.text = item.name
        timeLabel.text = item.getDuration()
        reviewLabel.text = item.rating
        numberLabel.text = "\(index)"
        if route == nil {
//            lowerPart.backgroundColor = .white
            lowerPart.isHidden = true
        } else {
            lowerPart.isHidden = false
            if route?.type == FooyoConstants.RouteType.PSV.rawValue {
                transportationIcon.applyBundleImage(name: "navigation_smallbus")
            } else {
                transportationIcon.applyBundleImage(name: "navigation_smallwalk")
            }
        }
        transportationLabel.text = route?.getTime()
        if index == 1 {
            lineOne.isHidden = true
            lineThree.isHidden = true
            lineTwo.isHidden = false
            lineFour.isHidden = false
        }
        self.route = route
    }

}
