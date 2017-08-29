//
//  ItineraryTableViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 20/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
//protocol ItineraryTableViewCellDelegate: class {
//    func displayTickets(itinerary: Itinerary)
//}

class ItineraryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "itineraryTableViewCell"
    fileprivate var fakeItem: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "page_myplanitem")
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
        contentView.backgroundColor = .white
        contentView.addSubview(fakeItem)
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewHandler))
//        fakeItem.addGestureRecognizer(gesture)
        fakeItem.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
//class ItineraryTableViewCell: UITableViewCell {
//    static let reuseIdentifier = "itineraryTableViewCell"
////    weak var delegate: ItineraryTableViewCellDelegate?
//    
//    fileprivate var itinerary: FooyoItinerary?
//    
//    fileprivate var bgView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .white
//        t.layer.shadowColor = UIColor.sntBlack8.cgColor
//        t.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
//        t.layer.shadowRadius = Scale.scaleY(y: 6)
//        t.layer.shadowOpacity = 1
//        return t
//    }()
//    
//    fileprivate var containerView: UIView! = {
//        let t = UIView()
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 4
//        t.layer.borderWidth = 1
//        t.layer.borderColor = UIColor.sntWhite.cgColor
//        return t
//    }()
//    
//    fileprivate var nameLabel: UILabel! = {
//        let t = UILabel()
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
//        t.textColor = UIColor.sntGreyishBrown
//        t.numberOfLines = 0
//        return t
//    }()
//    fileprivate var numLabel: UILabel! = {
//        let t = UILabel()
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 13))
//        t.textColor = UIColor.sntWarmGrey
//        t.numberOfLines = 0
//        return t
//    }()
//    fileprivate var collectionView: UICollectionView! = {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: Scale.scaleX(x: 75), height: Scale.scaleY(y: 89))
//        layout.minimumInteritemSpacing = 2
//        layout.minimumLineSpacing = 2
//        layout.scrollDirection = .horizontal
//        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
//        t.register(ItinerarySummaryCollectionViewCell.self, forCellWithReuseIdentifier: ItinerarySummaryCollectionViewCell.reuseIdentifier)
//        t.alwaysBounceHorizontal = true
//        t.backgroundColor = UIColor.sntWhiteTwo
//        return t
//    }()
//    fileprivate var ticketView: UIImageView! = {
//        let t = UIImageView()
//        t.contentMode = .center
//        t.image = #imageLiteral(resourceName: "icon_show").imageByReplacingContentWithColor(color: UIColor.sntMelon)
//        t.layer.cornerRadius = Scale.scaleY(y: 22.5) / 2
//        t.layer.borderColor = UIColor.sntMelon.cgColor
//        t.layer.borderWidth = 1.5
//        t.clipsToBounds = true
//        t.isUserInteractionEnabled = true
//        return t
//    }()
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        clipsToBounds = true
//        layoutMargins = UIEdgeInsets.zero
//        preservesSuperviewLayoutMargins = false
//        contentView.backgroundColor = .white
//        contentView.addSubview(bgView)
//        contentView.addSubview(containerView)
//        containerView.addSubview(nameLabel)
//        containerView.addSubview(numLabel)
//        containerView.addSubview(collectionView)
//        containerView.addSubview(ticketView)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(ticketHandler))
//        ticketView.addGestureRecognizer(gesture)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func ticketHandler() {
//        delegate?.displayTickets(itinerary: self.itinerary!)
//    }
//    
//    func configureWith(itinerary: Itinerary) {
//        self.itinerary = itinerary
//        nameLabel.text = itinerary.name
//        numLabel.text = "\((itinerary.items?.count)!)" + " places"
//        collectionView.reloadData()
//        setConstraints()
//    }
//    
//    func setConstraints() {
//        bgView.snp.remakeConstraints { (make) in
//            make.edges.equalTo(containerView)
//        }
//        containerView.snp.remakeConstraints { (make) in
//            make.top.equalTo(Scale.scaleY(y: 8))
//            make.leading.equalTo(Scale.scaleX(x: 16))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.bottom.equalTo(Scale.scaleY(y: -8))
//        }
//        nameLabel.snp.remakeConstraints { (make) in
//            make.top.equalTo(Scale.scaleY(y: 16))
//            make.leading.equalTo(Scale.scaleX(x: 16))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.height.equalTo(nameLabel.heightForLabel(width: Constants.mainWidth - 2 * Scale.scaleX(x: 32)))
//        }
//        numLabel.snp.remakeConstraints { (make) in
//            make.leading.equalTo(nameLabel)
//            make.trailing.equalTo(nameLabel)
//            make.top.equalTo(nameLabel.snp.bottom).offset(Scale.scaleY(y: 4))
//            make.height.equalTo(numLabel.heightForLabel(width: Constants.mainWidth - 2 * Scale.scaleX(x: 32)))
//        }
//        collectionView.snp.remakeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.top.equalTo(numLabel.snp.bottom).offset(Scale.scaleY(y: 16))
//        }
//        ticketView.snp.makeConstraints { (make) in
//            make.height.width.equalTo(Scale.scaleY(y: 22.5))
//            make.trailing.equalTo(Scale.scaleX(x: -16))
//            make.centerY.equalTo(nameLabel.snp.bottom)
//        }
//    }
//
//    static func estimatedCellHeight(_ itinerary: Itinerary) -> CGFloat {
//        let height1 = Scale.scaleY(y: 8)
//        let height2 = Scale.scaleY(y: 16)
//        let height3 = Scale.scaleY(y: 4)
//        let height4 = Scale.scaleY(y: 16)
//        let height5 = UILabel().heightForLabel("test", font: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16)), width: Constants.mainWidth)
//        let height6 = UILabel().heightForLabel("test", font: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 13)), width: Constants.mainWidth)
//        return 2 * height1 + height2 + height3 + height4 + height5 + height6 + Scale.scaleY(y: 89)
//    }
//}
//
//
//extension ItineraryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let items = itinerary?.items {
//            return items.count
//        }
//        return 0
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItinerarySummaryCollectionViewCell.reuseIdentifier, for: indexPath) as! ItinerarySummaryCollectionViewCell
//        let item = (itinerary?.items)![indexPath.row]
//        cell.configureWith(item: item)
//        return cell
//    }
//}
