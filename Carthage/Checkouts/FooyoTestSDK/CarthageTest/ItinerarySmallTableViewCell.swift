//
//  ItinerarySmallTableViewCell.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 18/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
protocol ItinerarySmallTableViewCellDelegate: class {
    func ItinerarySmallTableViewCellDidTapped(itinerary: FooyoItinerary)
}
class ItinerarySmallTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ItinerarySmallTableViewCell"
    weak var delegate: ItinerarySmallTableViewCellDelegate?

    fileprivate var itinerary: FooyoItinerary?
    
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.black
        t.numberOfLines = 0
        return t
    }()
    fileprivate var tagLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospGrey
        t.numberOfLines = 0
        return t
    }()
    fileprivate var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: Scale.scaleY(y: 75), height: Scale.scaleY(y: 75))
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let t = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        t.register(ItinerarySummaryCollectionViewCell.self, forCellWithReuseIdentifier: ItinerarySummaryCollectionViewCell.reuseIdentifier)
        t.register(ItinerarySummaryMapCollectionViewCell.self, forCellWithReuseIdentifier: ItinerarySummaryMapCollectionViewCell.reuseIdentifier)
        t.alwaysBounceHorizontal = true
        t.backgroundColor = UIColor.white
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = .white
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        collectionView.addGestureRecognizer(gesture)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func gestureHandler() {
        if let itinerary = itinerary {
            delegate?.ItinerarySmallTableViewCellDidTapped(itinerary: itinerary.makeCopy())
        }
    }

    func configureWith(itinerary: FooyoItinerary) {
        self.itinerary = itinerary
        nameLabel.text = itinerary.name
        tagLabel.text = itinerary.getSummaryTag()
        collectionView.reloadData()
        setConstraints()
    }
    
    func setConstraints() {
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 5))
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
        }
        tagLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(Scale.scaleY(y: 2))
        }
        collectionView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(Scale.scaleY(y: -1))
            make.top.equalTo(tagLabel.snp.bottom).offset(Scale.scaleY(y: 1))
        }
    }
}


extension ItinerarySmallTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = itinerary?.items {
            return items.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItinerarySummaryMapCollectionViewCell.reuseIdentifier, for: indexPath) as! ItinerarySummaryMapCollectionViewCell
//            cell.configureWith(plan: itinerary!)
//            return cell
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItinerarySummaryCollectionViewCell.reuseIdentifier, for: indexPath) as! ItinerarySummaryCollectionViewCell
        let item = (itinerary?.items)![indexPath.row]
        cell.configureWith(item: item)
        return cell
    }
    
}
