////
////  ThemeCollectionViewCell.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 14/4/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//
//class ThemeCollectionViewCell: UICollectionViewCell {
//    static let reuseIdentifier = "themeCollectionViewCell"
//
//    fileprivate var imageView: UIImageView! = {
//        let t = UIImageView()
//        t.clipsToBounds = true
//        t.layer.cornerRadius = 4
//        t.contentMode = .scaleAspectFill
//        t.backgroundColor = UIColor.sntWhite
//        return t
//    }()
//    
//    fileprivate var nameLabel: UILabel! = {
//        let t = UILabel()
//        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 24))
//        t.numberOfLines = 0
//        t.textColor = .white
//        return t
//    }()
//    
//    fileprivate var selectedIcon: UIImageView! = {
//        let t = UIImageView()
//        t.contentMode = .scaleAspectFit
//        t.applyBundleImage(name: "theme_selected", replaceColor: UIColor.sntTomato)
////        t.image = #imageLiteral(resourceName: "theme_selected").imageByReplacingContentWithColor(color: UIColor.sntTomato)
//        return t
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .white
//        contentView.addSubview(imageView)
////        contentView.addSubview(overLay)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(selectedIcon)
//        selectedIcon.isHidden = true
//        setConstraints()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setConstraints() {
//        imageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
////        overLay.snp.makeConstraints { (make) in
////            make.edges.equalTo(imageView)
////        }
//        nameLabel.snp.makeConstraints { (make) in
//            make.leading.equalTo(Scale.scaleX(x: 16))
//            make.trailing.equalTo(Scale.scaleX(x: -13))
//            make.bottom.equalTo(Scale.scaleY(y: -29))
//        }
//        selectedIcon.snp.makeConstraints { (make) in
////            make.center.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(Scale.scaleY(y: -20))
//            make.height.width.equalTo(Scale.scaleY(y: 70))
//        }
//    }
//    
//    func configureWith(theme: Constants.ThemeName) {
//        nameLabel.text = theme.rawValue
//        switch theme {
//        case .Culture:
////            imageView.image = #imageLiteral(resourceName: "theme_1_culture_heritage")
//            //  Converted with Swiftify v1.0.6402 - https://objectivec2swift.com/
//            imageView.applyBundleImage(name: "theme_1_culture_heritage")
//        case .Family:
//            imageView.applyBundleImage(name: "theme_2_family_fun")
////            imageView.image = #imageLiteral(resourceName: "theme_2_family_fun")
//        case .Hip:
//            imageView.applyBundleImage(name: "theme_3_hip_hangouts")
////            imageView.image = #imageLiteral(resourceName: "theme_3_hip_hangouts")
//        case .Nature:
//            imageView.applyBundleImage(name: "theme_4_nature_wildlife")
////            imageView.image = #imageLiteral(resourceName: "theme_4_nature_wildlife")
//        case .Thrill:
//            imageView.applyBundleImage(name: "theme_5_thrills_adventures")
////            imageView.image = #imageLiteral(resourceName: "theme_5_thrills_adventures")
//        default:
//            imageView.applyBundleImage(name: "theme_6_culture_heritage")
////            imageView.image = #imageLiteral(resourceName: "theme_1_culture_heritage")
//        }
////        let size = CGSize(width: contentView.frame.width, height: contentView.frame.height)
////        imageView.af_setImage(
////            withURL: NSURL(string: image)! as URL,
////            placeholderImage: UIImage(),
////            filter: AspectScaledToFillSizeFilter(size: size),
////            imageTransition: .crossDissolve(Constants.imageLoadTime)
////        )
//    }
//    
//    func selected() {
//        selectedIcon.isHidden = false
//    }
//    
//    func deselected() {
//        selectedIcon.isHidden = true
//    }
//    
////    override func draw(_ rect: CGRect) {
////        super.draw(rect)
//
////        overLay.applyGradient(colours: [UIColor(white: 0, alpha: 0.18), UIColor(white: 0, alpha: 0.76)])
////    }
//}
