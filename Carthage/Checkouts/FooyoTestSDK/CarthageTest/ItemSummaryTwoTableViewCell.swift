//
//  ItemSummaryTwoTableViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 27/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemSummaryTwoTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ItemSummaryTwoTableViewCell"
    
    fileprivate var overLay: UIView! = {
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
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    fileprivate var tagLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    
    fileprivate var rightIconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_detailarrow")
        return t
    }()
    
    fileprivate var reviewView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_review")
        return t
    }()
    fileprivate var reviewRatingOne: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_emptyreview")
        return t
    }()
    
    fileprivate var reviewRatingTwo: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_emptyreview")
        return t
    }()
    
    fileprivate var reviewRatingThree: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_emptyreview")
        return t
    }()
    
    fileprivate var reviewRatingFour: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_emptyreview")
        return t
    }()
    
    fileprivate var reviewRatingFive: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.clipsToBounds = true
        t.backgroundColor = .clear
        t.applyBundleImage(name: "plan_emptyreview")
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
        contentView.addSubview(container)
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(tagLabel)
        container.addSubview(rightIconView)
        container.addSubview(reviewView)
        container.addSubview(reviewRatingOne)
        container.addSubview(reviewRatingTwo)
        container.addSubview(reviewRatingThree)
        container.addSubview(reviewRatingFour)
        container.addSubview(reviewRatingFive)
        contentView.addSubview(overLay)

        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
        //        fakeItem.addGestureRecognizer(gesture)
        
        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(Scale.scaleY(y: -6))
        }
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Scale.scaleX(x: 15))
            make.width.height.equalTo(Scale.scaleY(y: 60))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(Scale.scaleX(x: 9))
            make.trailing.equalTo(rightIconView.snp.leading).offset(Scale.scaleX(x: -9))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Scale.scaleY(y: 5))
            make.leading.equalTo(iconView.snp.trailing).offset(Scale.scaleX(x: 9))
            make.trailing.equalTo(rightIconView.snp.leading).offset(Scale.scaleX(x: -9))
        }
        
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 20))
            make.trailing.equalTo(Scale.scaleX(x: -15))
        }
        reviewView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(iconView)
            make.height.equalTo(Scale.scaleY(y: 15))
            make.width.equalTo(Scale.scaleX(x: 25))
        }
        reviewRatingOne.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 10))
            make.centerY.equalTo(reviewView)
            make.leading.equalTo(reviewView.snp.trailing).offset(Scale.scaleX(x: 7))
        }
        reviewRatingTwo.snp.makeConstraints { (make) in
            make.height.width.equalTo(reviewRatingOne)
            make.leading.equalTo(reviewRatingOne.snp.trailing)
            make.centerY.equalTo(reviewView)
        }
        reviewRatingThree.snp.makeConstraints { (make) in
            make.height.width.equalTo(reviewRatingOne)
            make.leading.equalTo(reviewRatingTwo.snp.trailing)
            make.centerY.equalTo(reviewView)
        }
        reviewRatingFour.snp.makeConstraints { (make) in
            make.height.width.equalTo(reviewRatingOne)
            make.leading.equalTo(reviewRatingThree.snp.trailing)
            make.centerY.equalTo(reviewView)
        }
        reviewRatingFive.snp.makeConstraints { (make) in
            make.height.width.equalTo(reviewRatingOne)
            make.leading.equalTo(reviewRatingFour.snp.trailing)
            make.centerY.equalTo(reviewView)
        }
        
        overLay.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(container.snp.bottom)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(item: FooyoItem) {
        titleLabel.text = item.name
        tagLabel.text = item.getTag()
        if let url = item.coverImages {
            let width = Scale.scaleY(y: 60)
            let height = Scale.scaleY(y: 60)
            let size = CGSize(width: width, height: height)
            iconView.af_setImage(
                withURL: NSURL(string: url)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        if item.rating == nil {
            reviewRatingFive.isHidden = true
            reviewRatingFour.isHidden = true
            reviewRatingThree.isHidden = true
            reviewRatingTwo.isHidden = true
            reviewRatingOne.isHidden = true
            reviewView.isHidden = true
        } else {
            reviewRatingFive.isHidden = false
            reviewRatingFour.isHidden = false
            reviewRatingThree.isHidden = false
            reviewRatingTwo.isHidden = false
            reviewRatingOne.isHidden = false
            reviewView.isHidden = false
            reviewRatingOne.applyBundleImage(name: "plan_emptyreview")
            reviewRatingTwo.applyBundleImage(name: "plan_emptyreview")
            reviewRatingThree.applyBundleImage(name: "plan_emptyreview")
            reviewRatingFour.applyBundleImage(name: "plan_emptyreview")
            reviewRatingFive.applyBundleImage(name: "plan_emptyreview")
            switch (item.rating)! {
            case 0:
                break
            case 0.5:
                reviewRatingOne.applyBundleImage(name: "plan_halfreview")
            case 1:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
            case 1.5:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_halfreview")
            case 2:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
            case 2.5:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_halfreview")
            case 3:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_fullreview")
            case 3.5:
                
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_fullreview")
                reviewRatingFour.applyBundleImage(name: "plan_halfreview")
            case 4:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_fullreview")
                reviewRatingFour.applyBundleImage(name: "plan_fullreview")
            case 4.5:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_fullreview")
                reviewRatingFour.applyBundleImage(name: "plan_fullreview")
                reviewRatingFive.applyBundleImage(name: "plan_halfreview")
            default:
                reviewRatingOne.applyBundleImage(name: "plan_fullreview")
                reviewRatingTwo.applyBundleImage(name: "plan_fullreview")
                reviewRatingThree.applyBundleImage(name: "plan_fullreview")
                reviewRatingFour.applyBundleImage(name: "plan_fullreview")
                reviewRatingFive.applyBundleImage(name: "plan_fullreview")
            }
        }
    }


}
