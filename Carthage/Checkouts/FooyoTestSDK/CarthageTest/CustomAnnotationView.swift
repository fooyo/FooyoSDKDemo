//
//  CustomAnnotationView.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 23/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireImage

class CustomAnnotationView: MGLAnnotationView {
    var iconView: UIImageView! = {
        let t = UIImageView()
        return t
    }()
//    var overLayView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = UIColor.sntDarkGreyBlue46
//        return t
//    }()
    var indexLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 13))
        t.textAlignment = .center
        t.textColor = UIColor.ospSentosaBlue
        t.backgroundColor = .clear
        return t
    }()
//
    override func layoutSubviews() {
        super.layoutSubviews()
//        clipsToBounds = true
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        
        addSubview(iconView)
//        addSubview(overLayView)
        addSubview(indexLabel)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        indexLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        indexLabel.isHidden = true
        switch (reuseIdentifier)! {
        case FooyoConstants.AnnotationId.ItineraryItem.rawValue:
            layer.cornerRadius = Scale.scaleY(y: 25) / 2
            layer.borderColor = UIColor.ospSentosaBlue.cgColor
            layer.borderWidth = 5
            backgroundColor = .white
            indexLabel.isHidden = false
        case FooyoConstants.AnnotationId.UserMarker.rawValue:
            layer.cornerRadius = 0
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 0
            iconView.contentMode = .scaleAspectFit
            iconView.backgroundColor = .clear
            backgroundColor = .clear
            layer.borderWidth = 0
            iconView.image = UIImage.getBundleImage(name: "basemap_marker").withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -frame.height / 2, right: 0))
        default:
            layer.cornerRadius = Scale.scaleY(y: 12) / 2
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            if let anno = annotation as? MyCustomPointAnnotation {
                backgroundColor = anno.item?.category?.getColor()
            }
        }
    }
}
