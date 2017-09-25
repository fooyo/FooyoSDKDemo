//
//  ItineraryTableViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 20/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
protocol ItineraryTableViewCellDelegate: class {
    func ItineraryTableViewCellDidTapped(itinerary: FooyoItinerary)
}

class ItineraryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "itineraryTableViewCell"
    weak var delegate: ItineraryTableViewCellDelegate?
    
    fileprivate var itinerary: FooyoItinerary?
    
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 18))
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
        layout.itemSize = CGSize(width: Scale.scaleY(y: 110), height: Scale.scaleY(y: 110))
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
    
    fileprivate var lineView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.ospGrey50
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
        contentView.addSubview(lineView)
        collectionView.delegate = self
        collectionView.dataSource = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        collectionView.addGestureRecognizer(gesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureHandler() {
//        debugPrint("testing")
        if let itinerary = itinerary {
            delegate?.ItineraryTableViewCellDidTapped(itinerary: itinerary)
        }
    }
    func configureWith(itinerary: FooyoItinerary, hideLine: Bool = false) {
        self.itinerary = itinerary
        nameLabel.text = itinerary.name
        tagLabel.text = itinerary.getSummaryTag()
        if hideLine {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
        collectionView.reloadData()
        
        setConstraints()
    }
    
    func setConstraints() {
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 10))
            make.leading.equalTo(Scale.scaleX(x: 10))
            make.trailing.equalTo(Scale.scaleX(x: -10))
        }
        tagLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(Scale.scaleY(y: 5))
        }
        collectionView.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(Scale.scaleY(y: -4))
            make.top.equalTo(tagLabel.snp.bottom).offset(Scale.scaleY(y: 3))
        }
        lineView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}


extension ItineraryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
