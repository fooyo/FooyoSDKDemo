//
//  ItineraryMapCollectionViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 17/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage
protocol ItineraryMapCollectionViewCellDelegate: class {
    func didTapRoute(route: FooyoRoute)
    func didTapNavigation(item: FooyoItem)
}
class ItineraryMapCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "itineraryMapCollectionViewCell"
    weak var delegate: ItineraryMapCollectionViewCellDelegate?
    
    fileprivate var route: FooyoRoute?
    fileprivate var item: FooyoItem?
    fileprivate var itemContentView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.clipsToBounds = true
        t.layer.cornerRadius = 4
        return t
    }()
    fileprivate var avatarView: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = UIColor.ospWhite
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        t.layer.cornerRadius = 6
        return t
    }()
    var nameLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.black
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    var tagLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospGrey
        return t
    }()
    
    fileprivate var startLabel: UILabel! = {
        let t = UILabel()
        return t
    }()
    
    fileprivate var visitLabel: UILabel! = {
        let t = UILabel()
        return t
    }()
    var navView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    var navBtn: UIButton! = {
        let t = UIButton()
        t.backgroundColor = UIColor.ospSentosaGreen
        t.layer.cornerRadius = Scale.scaleY(y: 30) / 2
        t.alpha = 0.9
        return t
    }()
    var timeLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.ospDarkGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 13))
        t.text = "10\nmins"
        t.textAlignment = .center
        t.numberOfLines = 2
        return t
    }()
    
    var goBtn: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospSentosaOrange
        t.layer.cornerRadius = Scale.scaleY(y: 30) / 2
        t.isUserInteractionEnabled = true
        return t
    }()
    
    var goBtnInside: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_direction")
        t.contentMode = .scaleAspectFit
        return t
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
        contentView.layer.shadowRadius = Scale.scaleY(y: 6)
        contentView.layer.shadowOpacity = 1
        contentView.alpha = 0.92
        contentView.addSubview(itemContentView)
        itemContentView.addSubview(avatarView)
        itemContentView.addSubview(nameLabel)
        itemContentView.addSubview(tagLabel)
        itemContentView.addSubview(startLabel)
        itemContentView.addSubview(visitLabel)
        itemContentView.addSubview(goBtn)
        goBtn.addSubview(goBtnInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goHandler))
        goBtn.addGestureRecognizer(gesture)
        contentView.addSubview(navView)
        
        navView.addSubview(navBtn)
        navView.addSubview(timeLabel)
        navBtn.addTarget(self, action: #selector(navHandler), for: .touchUpInside)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goHandler() {
        if let item = self.item {
            delegate?.didTapNavigation(item: item)
        }
    }
    func navHandler() {
        if let route = route {
            delegate?.didTapRoute(route: route)
        }
    }
    
    func setConstraints() {
        itemContentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Scale.scaleX(x: 8))
            make.trailing.equalTo(navView.snp.leading)
        }
        avatarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Scale.scaleY(y: 5))
            make.bottom.equalToSuperview().offset(Scale.scaleY(y: -5))
            make.leading.equalToSuperview().offset(Scale.scaleX(x: 5))
            make.width.equalTo(avatarView.snp.height)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarView.snp.trailing).offset(Scale.scaleX(x: 16))
            make.trailing.equalToSuperview().offset(Scale.scaleX(x: -16))
            make.top.equalToSuperview().offset(Scale.scaleY(y: 16))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)//.offset(Scale.scaleY(y: <#T##CGFloat#>))
            make.trailing.equalTo(nameLabel)
        }
        startLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
            make.bottom.equalTo(visitLabel.snp.top).offset(Scale.scaleY(y: -5))
        }
        visitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
            make.bottom.equalTo(Scale.scaleY(y: -10))
        }
        navView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.width.equalTo(Scale.scaleY(y: 30) + Scale.scaleX(x: 8))
            make.centerY.equalToSuperview()
        }
        navBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Scale.scaleY(y: 30))
            make.top.equalToSuperview()
            make.bottom.equalTo(timeLabel.snp.top).offset(Scale.scaleY(y: -5))
            make.trailing.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(navBtn)
            make.bottom.equalToSuperview()
        }
        goBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 30))
            make.bottom.equalTo(Scale.scaleY(y: -5))
            make.trailing.equalTo(Scale.scaleX(x: -5))
        }
        goBtnInside.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 19))
            make.center.equalToSuperview()
        }
    }
    
    func configureWith(item: FooyoItem, route: FooyoRoute? = nil, isLowBudgetVisiting: Bool = false) {
        self.item = item
        self.route = route
        
        if let image = item.coverImages {
            let size = CGSize(width: Scale.scaleX(x: 72), height: Scale.scaleY(y: 106))
            avatarView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        nameLabel.text = item.name
        tagLabel.text = item.getTag()
        var strOne = NSMutableAttributedString(string: "Arrival time: ", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.ospSentosaBlue])
        var strTwo = NSMutableAttributedString(string: item.getArrivalTime(), attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])
        if let time = item.arrivingTime {
            let timeStr = DateTimeTool.fromFormatThreeToFormatOne(date: time)
            strTwo = NSMutableAttributedString(string: timeStr, attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])
        }
        strOne.append(strTwo)
        startLabel.attributedText = strOne
        
        strOne = NSMutableAttributedString(string: "Play time: ", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.ospSentosaBlue])
        strTwo = NSMutableAttributedString(string: "Pending", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])

        if let time = item.visitingTime {
            if isLowBudgetVisiting {
                strTwo = NSMutableAttributedString(string: item.getLowBudgetVisitingTime(), attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])
            } else {
                strTwo = NSMutableAttributedString(string: item.getVisitingTime(), attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])
            }
        }
        strOne.append(strTwo)
        visitLabel.attributedText = strOne

        if route == nil {
            navBtn.backgroundColor = UIColor.clear
            navBtn.setImage(UIImage.getBundleImage(name: "basemap_marker"), for: .normal)
            timeLabel.text = "End"
            timeLabel.textColor = UIColor.ospSentosaRed
        } else {
            timeLabel.textColor = UIColor.ospSentosaGreen
            timeLabel.text = "\(route!.getTimeInTwoLines())"
            navBtn.backgroundColor = UIColor.ospSentosaGreen
            if route?.type == FooyoConstants.RouteType.PSV.rawValue {
                navBtn.setImage(UIImage.getBundleImage(name: "navigation_smallbus", replaceColor: .white), for: .normal)
            } else {
                navBtn.setImage(UIImage.getBundleImage(name: "navigation_smallwalk", replaceColor: .white), for: .normal)
            }
        }
    }
}
