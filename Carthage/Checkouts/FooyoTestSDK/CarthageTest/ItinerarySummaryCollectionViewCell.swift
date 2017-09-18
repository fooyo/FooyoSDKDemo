//
//  ItinerarySummaryCollectionViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 20/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class ItinerarySummaryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "itinerarySummaryCollectionViewCell"
    fileprivate var imageView: UIImageView! = {
        let t = UIImageView()
        t.clipsToBounds = true
        t.contentMode = .scaleAspectFill
        t.backgroundColor = UIColor.ospWhite
        t.layer.cornerRadius = 5
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configureWith(item: FooyoItem) {
        if let image = item.coverImages {
            let size = CGSize(width: Scale.scaleY(y: 110), height: Scale.scaleY(y: 110))
            imageView.af_setImage(
                withURL: NSURL(string: image)! as URL,
                placeholderImage: UIImage(),
                filter: AspectScaledToFillSizeFilter(size: size),
                imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
            )
        }

    }
}
