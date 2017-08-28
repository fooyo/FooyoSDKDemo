////
////  CustomCalloutViewItinerary.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 15/4/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import Foundation
//import Mapbox
//import UIKit
//
//protocol CustomCalloutViewItineraryDelegate: class {
//    func didTapStart(item: Item)
//    func didTapAdd(item: Item)
//    func didTapRemove(item: Item)
//    func dismiss()
//}
//
//class CustomCalloutViewItinerary: UIView, MGLCalloutView {
//    weak var userDelegate: CustomCalloutViewItineraryDelegate?
//    
//    var representedObject: MGLAnnotation
//    var inItinerary: Bool = false
//    var item: Item?
//    // Lazy initialization of optional vars for protocols causes segmentation fault: 11s in Swift 3.0. https://bugs.swift.org/browse/SR-1825
//    
//    var leftAccessoryView = UIView() /* unused */
//    var rightAccessoryView = UIView() /* unused */
//    
//    weak var delegate: MGLCalloutViewDelegate?
//    
//    let tipHeight: CGFloat = 10.0
//    let tipWidth: CGFloat = 20.0
//    
//    fileprivate var containerView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = UIColor.sntDarkGrey80
//        t.layer.cornerRadius = Scale.scaleY(y: 8)
//        t.clipsToBounds = true
//        return t
//    }()
//    
//    fileprivate var removeButton: UIButton! = {
//        let t = UIButton()
//        t.backgroundColor = .clear
//        t.setTitle("Remove", for: .normal)
//        t.setTitleColor(.white, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        return t
//    }()
//    fileprivate var addButton: UIButton! = {
//        let t = UIButton()
//        t.backgroundColor = .clear
//        t.setTitle("Add", for: .normal)
//        t.setTitleColor(.white, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        return t
//    }()
//    fileprivate var startButton: UIButton! = {
//        let t = UIButton()
//        t.backgroundColor = .clear
//        t.setTitle("Start Here", for: .normal)
//        t.setTitleColor(.white, for: .normal)
//        t.titleLabel?.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
//        return t
//    }()
//    fileprivate var lineView: UIView! = {
//        let t = UIView()
//        t.backgroundColor = .white
//        return t
//    }()
//    
//    required init(representedObject: MGLAnnotation) {
//        self.representedObject = representedObject
//        super.init(frame: .zero)
//        
//        backgroundColor = .clear
//        
//        self.layer.shadowColor = UIColor.sntBlack13.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: Scale.scaleY(y: 5))
//        self.layer.shadowRadius = Scale.scaleY(y: 14)
//        self.layer.shadowOpacity = 1
//        addSubview(containerView)
//        containerView.addSubview(removeButton)
//        containerView.addSubview(addButton)
//        containerView.addSubview(lineView)
//        containerView.addSubview(startButton)
//        
//        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
//        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
//        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
//        
//        if let rep = self.representedObject as? MyCustomPointAnnotation {
//            if let item = rep.item {
//                self.item = item
//            }
//        }
//        
//        containerView.snp.makeConstraints { (make) in
//            make.leading.equalTo(0)
//            make.trailing.equalTo(0)
//            make.top.equalTo(0)
//            make.bottom.equalTo(-tipHeight)
//        }
//        removeButton.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalTo(Scale.scaleX(x: 75))
//        }
//        lineView.snp.makeConstraints { (make) in
//            make.leading.equalTo(removeButton.snp.trailing)
//            make.top.equalToSuperview().offset(Scale.scaleY(y: 5))
//            make.bottom.equalToSuperview().offset(Scale.scaleY(y: -5))
//            make.width.equalTo(0.5)
//        }
//        addButton.snp.makeConstraints { (make) in
//            make.edges.equalTo(removeButton)
//        }
//        startButton.snp.makeConstraints { (make) in
//            make.leading.equalTo(lineView.snp.trailing)
//            make.trailing.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//    }
//    
//    required init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func didTapAdd() {
//        debugPrint("add")
//        self.userDelegate?.didTapAdd(item: item!)
//    }
//    func didTapRemove() {
//        self.userDelegate?.didTapRemove(item: item!)
//    }
//    func didTapStart() {
//        self.userDelegate?.didTapStart(item: item!)
//    }
//    
//    // MARK: - MGLCalloutView API
//    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
//        if !representedObject.responds(to: #selector(getter: UIPreviewActionItem.title)) {
//            return
//        }
//        
//        view.addSubview(self)
//        if inItinerary {
//            removeButton.isHidden = false
//            addButton.isHidden = true
//        } else {
//            removeButton.isHidden = true
//            addButton.isHidden = false
//        }
//        if isCalloutTappable() {
//            // Handle taps and eventually try to send them to the delegate (usually the map view)
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(CustomCalloutView.calloutTapped))
//            containerView.addGestureRecognizer(gesture)
//        } else {
//            // Disable tapping and highlighting
//            containerView.isUserInteractionEnabled = false
//        }
//        
//        //        // Prepare our frame, adding extra space at the bottom for the tip
//        let frameWidth: CGFloat = Scale.scaleX(x: 167.0)//mainBody.bounds.size.width
//        let frameHeight: CGFloat = Scale.scaleY(y: 40.0) + tipHeight
//        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
//        let frameOriginY = rect.origin.y - frameHeight
//        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
//        //        self.snp.makeConstraints { (make) in
//        //            make.width.equalTo(Scale.scaleX(x: 283))
//        //            make.height.equalTo(Scale.scaleY(y: 180) + tipHeight)
//        ////            make.centerY.equalToSuperview()
//        //            make.centerX.equalToSuperview()
//        //            make.bottom.equalTo((superview?.snp.centerY)!)
//        //        }
//        if animated {
//            alpha = 0
//            UIView.animate(withDuration: 0.2) { [weak self] in
//                self?.alpha = 1
//            }
//        }
//    }
//    
//    func dismissCallout(animated: Bool) {
//        userDelegate?.dismiss()
//        if (superview != nil) {
//            if animated {
//                UIView.animate(withDuration: 0.2, animations: { [weak self] in
//                    self?.alpha = 0
//                    }, completion: { [weak self] _ in
//                        self?.removeFromSuperview()
//                })
//            } else {
//                removeFromSuperview()
//            }
//        }
//    }
//    
//    // MARK: - Callout interaction handlers
//    func isCalloutTappable() -> Bool {
//        if let delegate = delegate {
//            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
//                return delegate.calloutViewShouldHighlight!(self)
//            }
//        }
//        return false
//    }
//    
//    func calloutTapped() {
//        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
//            delegate!.calloutViewTapped!(self)
//        }
//    }
//    
//    // MARK: - Custom view styling
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        // Draw the pointed tip at the bottom
//        let fillColor : UIColor = UIColor.sntDarkGrey80
//        //
//        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
//        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
//        let heightWithoutTip = rect.size.height - tipHeight
//        
//        let currentContext = UIGraphicsGetCurrentContext()!
//        
//        let tipPath = CGMutablePath()
//        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
//        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
//        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
//        tipPath.closeSubpath()
//        
//        fillColor.setFill()
//        currentContext.addPath(tipPath)
//        currentContext.fillPath()
//        
//    }
//}
