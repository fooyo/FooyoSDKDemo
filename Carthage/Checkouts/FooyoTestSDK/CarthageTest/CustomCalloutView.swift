//
//  CustomizeCalloutView.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 23/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox
import AlamofireImage

protocol CustomCalloutViewDelegate: class {
    func didTapDirection(item: FooyoItem)
}

class CustomCalloutView: UIView, MGLCalloutView {
    weak var userDelegate: CustomCalloutViewDelegate?
    
    var representedObject: MGLAnnotation
    var fromSource = FooyoConstants.PageSource.FromHomeMap
    
    // Lazy initialization of optional vars for protocols causes segmentation fault: 11s in Swift 3.0. https://bugs.swift.org/browse/SR-1825
    
    var leftAccessoryView = UIView() /* unused */
    var rightAccessoryView = UIView() /* unused */
    
    weak var delegate: MGLCalloutViewDelegate?
    
    let tipHeight: CGFloat = Scale.scaleY(y: 13)
    let tipWidth: CGFloat = Scale.scaleX(x: 34)
    
    fileprivate var containerView: UIView! = {
        let t = UIView()
        t.backgroundColor = .white
        t.layer.cornerRadius = Scale.scaleY(y: 4)
        t.clipsToBounds = true
        return t
    }()
    
    fileprivate var coverView: UIImageView! = {
        let t = UIImageView()
        t.backgroundColor = UIColor.ospWhite
        t.contentMode = .scaleAspectFill
        t.clipsToBounds = true
        return t
    }()
    fileprivate var nameLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.black
        return t
    }()
    fileprivate var tagLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.ospGrey
        return t
    }()
    fileprivate var reviewView: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "basemap_review")
        return t
    }()
    fileprivate var reviewLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.black
        t.contentMode = .scaleAspectFit
        return t
    }()
    fileprivate var expandView: UIImageView! = {
        let t = UIImageView()
        t.applyBundleImage(name: "general_rightarrow")
        t.contentMode = .scaleAspectFit
        return t
    }()
//    fileprivate var allBusView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .clear
//        return t
//    }()
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        
        //        guard self.representedObject is MGLPointAnnotation else {
        //            return
        //        }
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        self.layer.shadowColor = UIColor.ospBlack20.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 2))
        self.layer.shadowRadius = Scale.scaleY(y: 4)
        self.layer.shadowOpacity = 1
        
        addSubview(containerView)
        containerView.addSubview(coverView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(tagLabel)
        containerView.addSubview(reviewView)
        containerView.addSubview(reviewLabel)
        containerView.addSubview(expandView)
//        containerView.addSubview(buttonBG)
//        containerView.addSubview(directionButton)
//        
//        directionButton.addTarget(self, action: #selector(didTapBtn), for: .touchUpInside)
//        containerView.addSubview(nameLabel)
//        containerView.addSubview(stateLabel)
//        containerView.addSubview(markButton)
//        containerView.addSubview(allBusView)
        
//        if (representedObject.subtitle)! == "restroom" {
//            nameLabel.text = representedObject.title!!
//        } else {
//            nameLabel.text = representedObject.title!! + " >"
//        }
        if let rep = self.representedObject as? MyCustomPointAnnotation {
            if let image = rep.item?.coverImages {
                let width = Scale.scaleY(y: 70)
                let height = Scale.scaleY(y: 70)
                let size = CGSize(width: width, height: height)
                coverView.af_setImage(
                    withURL: NSURL(string: image)! as URL,
                    placeholderImage: UIImage(),
                    filter: AspectScaledToFillSizeFilter(size: size),
                    imageTransition: .crossDissolve(FooyoConstants.imageLoadTime)
                )
            }
            if let name = rep.item?.name {
                nameLabel.text = name
            }
            tagLabel.text = rep.item?.getTag()
            reviewLabel.text = parseOptionalString(input: rep.item?.rating, defaultValue: "Pending")
//            if let state = rep.item?.getState() {
//                stateLabel.text = state
//            }
//            if rep.item?.category == Constants.ItemType.BusStop.rawValue || rep.item?.category == Constants.ItemType.ExpressStop.rawValue {
//                stateLabel.isHidden = true
//                allBusView.isHidden = false
//                setupAllBusView(item: rep.item!)
//            } else {
//                stateLabel.isHidden = false
//                allBusView.isHidden = true
//            }
        }
        
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
//            make.bottom.equalTo(-tipHeight + 1)
            make.bottom.equalTo(-tipHeight + 2)
        }
        coverView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
//            make.height.equalTo(Scale.scaleY(y: 110))
//            make.height.equalTo(coverView.snp.width)
            make.width.equalTo(coverView.snp.height)
//            make.width.equalTo(100)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 8))
            make.leading.equalTo(coverView.snp.trailing).offset(Scale.scaleX(x: 10))
            make.trailing.equalTo(expandView.snp.leading).offset(Scale.scaleX(x: -10))
        }
        tagLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.trailing.equalTo(nameLabel)
        }
        reviewView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Scale.scaleY(y: 14.6))
            make.leading.equalTo(nameLabel)
            make.top.equalTo(tagLabel.snp.bottom).offset(Scale.scaleY(y: 6.1))
        }
        reviewLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(reviewView.snp.trailing).offset(Scale.scaleX(x: 4.9))
            make.centerY.equalTo(reviewView)
            make.trailing.equalTo(nameLabel)
        }
        expandView.snp.makeConstraints { (make) in
            make.trailing.equalTo(Scale.scaleX(x: -18))
            make.height.equalTo(Scale.scaleY(y: 16))
            make.width.equalTo(Scale.scaleX(x: 8))
            make.centerY.equalToSuperview()
        }
//        allBusView.snp.makeConstraints { (make) in
//            make.edges.equalTo(stateLabel)
//        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupAllBusView(item: Item) {
//        for each in allBusView.subviews {
//            each.snp.removeConstraints()
//            each.removeFromSuperview()
//        }
//        var subBusViews = [UIView]()
//        var subLabels = [UILabel]()
//        var index = 0
//        if let buses = item.buses {
//            for each in buses {
//                var num = 0
//                switch each.name! {
//                case "Beach Tram":
//                    num = 5
//                case "Express":
//                    num = 4
//                case "Bus1":
//                    num = 1
//                case "Bus2":
//                    num = 2
//                case "Bus3":
//                    num = 3
//                default:
//                    num = 0
//                }
//                
//                let busView = UILabel()
////                busView.layer.cornerRadius = Scale.scaleY(y: 2)
//                busView.clipsToBounds = true
//                busView.textColor = .white
//                busView.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
//                busView.text = Constants.routeNames[num]
//                busView.backgroundColor = Constants.routeColor[num]
//                busView.textAlignment = .center
//                
//                let label = UILabel()
////                label.textColor = .white
//                label.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
//                label.textColor = UIColor.sntWarmGrey
//                label.text = each.giveState()
//                
//                allBusView.addSubview(busView)
//                allBusView.addSubview(label)
//                subBusViews.append(busView)
//                subLabels.append(label)
//                
//                busView.snp.makeConstraints({ (make) in
//                    make.width.equalTo(Scale.scaleX(x: 50))
//                    make.leading.equalToSuperview()
//                    if index == 0 {
//                        make.top.equalToSuperview()
//                    } else {
//                        make.top.equalTo(subBusViews[index - 1].snp.bottom).offset(Scale.scaleY(y: 3))
//                    }
//                })
//                label.snp.makeConstraints({ (make) in
//                    make.leading.equalTo(busView.snp.trailing).offset(Scale.scaleX(x: 5))
////                    if index == 0 {
////                        make.top.equalToSuperview()
////                    } else {
////                        make.top.equalTo(subBusViews[index - 1].snp.bottom).offset(Scale.scaleY(y: 3))
////                    }
//                    make.centerY.equalTo(busView)
//                })
//                index += 1
//            }
//        }
//    }
//    func didTapBtn() {
//        if let rep = self.representedObject as? MyCustomPointAnnotation {
//            self.userDelegate?.didTapDirection(item: rep.item!)
//        }
//    }
    
    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: #selector(getter: UIPreviewActionItem.title)) {
            return
        }
//        if fromSource == Constants.PageSource.FromNavigation {
//            directionButton.isHidden = true
//            buttonBG.isHidden = true
//        } else {
//            directionButton.isHidden = false
//            buttonBG.isHidden = false
//        }
        view.addSubview(self)
        
        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(CustomCalloutView.calloutTapped))
            containerView.addGestureRecognizer(gesture)
        } else {
            // Disable tapping and highlighting
            containerView.isUserInteractionEnabled = false
        }
        
        //        // Prepare our frame, adding extra space at the bottom for the tip
        let frameWidth: CGFloat = Scale.scaleX(x: 280.0)//mainBody.bounds.size.width
        let frameHeight: CGFloat = Scale.scaleY(y: 70.0) + tipHeight// - stateLabel.heightForLabel("test", width: frameWidth) + stateLabel.heightForLabel(width: frameWidth)//mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        //        self.snp.makeConstraints { (make) in
        //            make.width.equalTo(Scale.scaleX(x: 283))
        //            make.height.equalTo(Scale.scaleY(y: 180) + tipHeight)
        ////            make.centerY.equalToSuperview()
        //            make.centerX.equalToSuperview()
        //            make.bottom.equalTo((superview?.snp.centerY)!)
        //        }
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    func dismissCallout(animated: Bool) {
        debugPrint("dismiss")
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    // MARK: - Callout interaction handlers
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    // MARK: - Custom view styling
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Draw the pointed tip at the bottom
        let fillColor : UIColor = .white
        //
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
        
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
                
    }
}
