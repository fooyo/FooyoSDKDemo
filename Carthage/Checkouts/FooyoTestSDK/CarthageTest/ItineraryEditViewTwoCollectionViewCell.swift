//
//  ItineraryEditViewTwoCollectionViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 21/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class ItineraryEditViewTwoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "itineraryEditViewTwoCollectionViewCell"
    
    fileprivate var overLay: UIView! = {
        let t = UIView()
        t.layer.cornerRadius = 4
        t.clipsToBounds = true
        t.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return t
    }()
    
    fileprivate var imageView: UIImageView! = {
        let t = UIImageView()
        t.clipsToBounds = true
        t.layer.cornerRadius = 4
        t.contentMode = .scaleAspectFill
        t.backgroundColor = UIColor.ospWhite
        return t
    }()
    
    fileprivate var arrivingLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 22))
        t.textColor = .white
        return t
    }()
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 13))
        t.numberOfLines = 2
        t.textColor = .white
        return t
    }()
    fileprivate var visitingLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = .white
        return t
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 4
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 4

        contentView.addSubview(imageView)
        contentView.addSubview(overLay)
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrivingLabel)
        contentView.addSubview(visitingLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        overLay.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 8))
            make.trailing.equalTo(Scale.scaleX(x: -8))
            make.bottom.equalTo(Scale.scaleY(y: -8))
        }
        arrivingLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(Scale.scaleY(y: 8))
        }
        visitingLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(arrivingLabel.snp.bottom)//.offset(Scale.scaleY(y: 5))
        }
    }
    
    func configureWith(item: FooyoItem, isLowBudgetVisiting: Bool = false) {
        debugPrint("check whether the budget is low \(isLowBudgetVisiting)")
        if let image = item.coverImages {
            let size = CGSize(width: Scale.scaleX(x: 98), height: Scale.scaleY(y: 92))
            imageView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }
        nameLabel.text = item.name
        if let time = item.arrivingTime {
            arrivingLabel.text = DateTimeTool.fromFormatThreeToFormatOne(date: time)
        }
        if isLowBudgetVisiting {
            visitingLabel.text = item.getLowBudgetVisitingTime()
        } else {
            visitingLabel.text = item.getVisitingTime()
        }
    }
    
    func highlight() {
        contentView.layer.borderColor = UIColor.ospSentosaOrange.cgColor
//        nameLabel.textColor = UIColor.sntTomato
//        arrivingLabel.textColor = UIColor.sntTomato
//        visitingLabel.textColor = UIColor.sntTomato
    }
    func deHighlight() {
        contentView.layer.borderColor = UIColor.clear.cgColor
//        nameLabel.textColor = UIColor.white
//        arrivingLabel.textColor = UIColor.white
//        visitingLabel.textColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        overLay.applyGradient(colours: [UIColor(white: 0, alpha: 0.18), UIColor(white: 0, alpha: 0.76)])
    }
}
