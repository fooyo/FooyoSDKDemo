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
//    var indexLabel: UILabel! = {
//        let t = UILabel()
//        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
//        t.textAlignment = .center
//        t.textColor = .white
//        return t
//    }()
//    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        addSubview(iconView)
//        addSubview(overLayView)
//        addSubview(indexLabel)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        switch (reuseIdentifier)! {
//        case "Ticketing Counters":
//            iconView.backgroundColor = UIColor.red
//        case "Events":
//            iconView.backgroundColor = UIColor.red
//        case "Prayer Rooms":
//            iconView.backgroundColor = UIColor.red
//        case "Attractions":
//            iconView.backgroundColor = UIColor.red
//        case "F&B":
//            iconView.backgroundColor = UIColor.red
//        case "Hotels & Spas":
//            iconView.backgroundColor = UIColor.red
//        case "Retail & Other Services":
//            iconView.backgroundColor = UIColor.red
//        case "Linear Trails":
//            iconView.backgroundColor = UIColor.red
//        case "Non-Linear Trails":
//            iconView.backgroundColor = UIColor.red
//        case "Rest Rooms":
//            iconView.backgroundColor = UIColor.red
//        case "Bus Stops":
//            iconView.backgroundColor = UIColor.red
//        case "Tram Stops":
//            iconView.backgroundColor = UIColor.red
//        case "Express Stations":
//            iconView.backgroundColor = UIColor.red
//        case "Cable Car Stations":
//            iconView.backgroundColor = UIColor.red
//        default:
//            break
//        }
        
        //        overLayView.snp.makeConstraints { (make) in
        //            make.edges.equalToSuperview()
        //        }
        //        indexLabel.snp.makeConstraints { (make) in
        //            make.edges.equalToSuperview()
        //        }
        //        overLayView.isHidden = true
        //        indexLabel.isHidden = true
        //        if frame.width > Scale.scaleY(y: 20) {
        //            iconView.isHidden = false
        //            layer.borderWidth = 2
        //            iconView.contentMode = .center
        //            let size = CGSize(width: frame.width * 0.8, height: frame.height * 0.8)
        //            switch reuseIdentifier! {
        //            case "attraction":
        //                iconView.image = #imageLiteral(resourceName: "icon_attraction")//.af_imageAspectScaled(toFit: size)
        //                iconView.backgroundColor = UIColor.sntDeepLavender
        //            case "restaurant":
        //                iconView.image = #imageLiteral(resourceName: "icon_restaurant")
        //                iconView.backgroundColor = UIColor.sntDarkGreyBlue
        //            case "show":
        //                iconView.image = #imageLiteral(resourceName: "icon_show")
        //                iconView.backgroundColor = UIColor.sntGreenishTeal
        //            case "shop":
        //                iconView.image = #imageLiteral(resourceName: "icon_shop")
        //                iconView.backgroundColor = UIColor.sntGoldenRod
        //            case "bus_stop":
        //                iconView.image = #imageLiteral(resourceName: "icon_bus")
        //                iconView.backgroundColor = UIColor.sntSalmon
        //            case "express_stop":
        //                iconView.image = #imageLiteral(resourceName: "icon_train")
        //                iconView.backgroundColor = UIColor.sntSalmon
        //            case "restroom":
        //                iconView.image = #imageLiteral(resourceName: "icon_toilet")
        //                iconView.backgroundColor = UIColor.sntDarkSkyBlue
        //            case Constants.AnnotationId.EndItem.rawValue, Constants.AnnotationId.StartItem.rawValue:
        //                iconView.contentMode = .scaleAspectFill
        //                iconView.backgroundColor = UIColor.sntWhite
        //                if let annotation = annotation as? MyCustomPointAnnotation {
        //                    if let images = annotation.item?.coverImages {
        //                        let image = images[0]
        //                        let width = frame.width
        //                        let height = frame.height
        //                        let size = CGSize(width: width, height: height)
        //                        iconView.af_setImage(
        //                            withURL: NSURL(string: image)! as URL,
        //                            placeholderImage: UIImage(),
        //                            filter: AspectScaledToFillSizeFilter(size: size),
        //                            imageTransition: .crossDissolve(Constants.imageLoadTime)
        //                        )
        //                    }
        //                }
        //            case Constants.AnnotationId.ItineraryItem.rawValue:
        //                overLayView.isHidden = false
        //                indexLabel.isHidden = false
        //                iconView.contentMode = .scaleAspectFill
        //                iconView.backgroundColor = UIColor.sntWhite
        //                if let annotation = annotation as? MyCustomPointAnnotation {
        //                    indexLabel.text = String(annotation.index! + 1)
        //                    if let images = annotation.item?.coverImages {
        //                        let image = images[0]
        //                        let width = frame.width
        //                        let height = frame.height
        //                        let size = CGSize(width: width, height: height)
        //                        iconView.af_setImage(
        //                            withURL: NSURL(string: image)! as URL,
        //                            placeholderImage: UIImage(),
        //                            filter: AspectScaledToFillSizeFilter(size: size),
        //                            imageTransition: .crossDissolve(Constants.imageLoadTime)
        //                        )
        //                    }
        //                }
        //            case Constants.AnnotationId.UserMarker.rawValue:
        //                iconView.contentMode = .scaleAspectFit
        //                iconView.backgroundColor = .clear
        //                backgroundColor = .clear
        //                layer.borderWidth = 0
        //                iconView.image = #imageLiteral(resourceName: "Marker_Filled").imageByReplacingContentWithColor(color: UIColor.sntRed).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -frame.height / 2, right: 0))
        //            default:
        //                break
        //            }
        //        } else {
        //            iconView.isHidden = true
        //            layer.borderWidth = 1
        //            switch reuseIdentifier! {
        //            case "attraction":
        //                backgroundColor = UIColor.sntDeepLavender
        //            case "restaurant":
        //                backgroundColor = UIColor.sntDarkGreyBlue
        //            case "show":
        //                backgroundColor = UIColor.sntGreenishTeal
        //            case "shop":
        //                backgroundColor = UIColor.sntGoldenRod
        //            case "bus_stop":
        //                backgroundColor = UIColor.sntSalmon
        //            case "express_stop":
        //                backgroundColor = UIColor.sntSalmon
        //            case "restroom":
        //                backgroundColor = UIColor.sntDarkSkyBlue
        //            default:
        //                break
        //            }
        //        }
        //        debugPrint(reuseIdentifier!)
    }
    
    func applyColor(annotation: MyCustomPointAnnotation) {
        if let color = annotation.item?.category?.getColor() {
            backgroundColor = color
        } else {
            backgroundColor = .black
        }
    }
}
