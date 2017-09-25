//
//  RouteListTableViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 7/3/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
protocol RouteListTableViewCellDelegate: class {
    func RouteListTableViewCellDelegateDidTap(route: FooyoRoute)
}

class RouteListTableViewCell: UITableViewCell {
    
    weak var delegate: RouteListTableViewCellDelegate?
    static let reuseIdentifier = "routeListTableViewCell"
    fileprivate var route: FooyoRoute?
    var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.black
        return t
    }()
    var subtitleOneLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    var subtitleTwoLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 10))
        t.textColor = UIColor.ospDarkGrey
        t.text = "This suggestion is based on traffic and weather."
        return t
    }()
    
    var infoContainer: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    var disLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 11))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    var timeLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11))
        t.textColor = UIColor.ospDarkGrey
        return t
    }()
    var instructionView: UIScrollView! = {
        let t = UIScrollView()
        t.backgroundColor  = .white
        t.alwaysBounceVertical = false
        t.alwaysBounceHorizontal = true
        return t
    }()
    var startIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_gps")
        return t
    }()
    var endIcon: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .scaleAspectFit
        t.applyBundleImage(name: "basemap_markersmall")
        return t
    }()
//
    var estimatedTimeLabel: UILabel! = {
        let t = UILabel()
        return t
    }()
    
    var queueTimeLabel: UILabel! = {
        let t = UILabel()
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleOneLabel)
        contentView.addSubview(subtitleTwoLabel)
        contentView.addSubview(infoContainer)
        infoContainer.addSubview(disLabel)
        infoContainer.addSubview(timeLabel)
        contentView.addSubview(instructionView)
        contentView.addSubview(estimatedTimeLabel)
        contentView.addSubview(queueTimeLabel)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler))
        instructionView.addGestureRecognizer(gesture)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureHandler() {
        if let route = route {
            delegate?.RouteListTableViewCellDelegateDidTap(route: route)
        }
    }
    
    func setSub(isHide: Bool) {
        if isHide {
            subtitleOneLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleLabel)
                make.height.equalTo(0)
                make.top.equalTo(titleLabel.snp.bottom)
            }
            subtitleTwoLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleLabel)
                make.height.equalTo(0)
                make.top.equalTo(subtitleOneLabel.snp.bottom)
            }
        } else {
            subtitleOneLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleLabel)
                make.height.equalTo(Scale.scaleY(y: 18))
                make.top.equalTo(titleLabel.snp.bottom)
            }
            subtitleTwoLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(titleLabel)
                make.height.equalTo(Scale.scaleY(y: 18))
                make.top.equalTo(subtitleOneLabel.snp.bottom)
            }
        }
    }
    func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(Scale.scaleY(y: 19))
            make.leading.equalTo(Scale.scaleX(x: 15))
            make.height.equalTo(Scale.scaleY(y: 20))
            make.trailing.equalTo(Scale.scaleX(x: -15))
        }
        infoContainer.snp.makeConstraints { (make) in
            make.trailing.equalTo(Scale.scaleX(x: -16))
            make.top.equalTo(subtitleTwoLabel.snp.bottom).offset(Scale.scaleY(y: 20))
            make.height.equalTo(Scale.scaleY(y: 28))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(infoContainer)
            make.trailing.equalTo(infoContainer)
            make.top.equalTo(infoContainer)
        }
        disLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(infoContainer)
            make.trailing.equalTo(infoContainer)
            make.bottom.equalTo(infoContainer)
            make.top.equalTo(timeLabel.snp.bottom)
        }
        instructionView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.height.equalTo(infoContainer)
            make.trailing.equalTo(infoContainer.snp.leading).offset(Scale.scaleX(x: -10))
            make.centerY.equalTo(infoContainer)
        }
        estimatedTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(instructionView.snp.bottom).offset(Scale.scaleY(y: 14))
            make.trailing.equalTo(titleLabel)
        }
        queueTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(estimatedTimeLabel.snp.bottom).offset(Scale.scaleY(y: 10))
        }
        
    }
    
    func configureWith(route: FooyoRoute) {
        self.route = route
        if (route.suggested)! {
            titleLabel.text = "Recommended"
            if (route.subType)!.lowercased().contains("fastest") {
                subtitleOneLabel.text = "Shortest timing"
            } else if (route.subType)!.lowercased().contains("sheltered") {
                subtitleOneLabel.text = "Most sheltered"
            }
            setSub(isHide: false)
        } else {
            if (route.subType)!.lowercased().contains("fastest") {
                titleLabel.text = "Shortest Timing"
            } else if (route.subType)!.lowercased().contains("sheltered") {
                titleLabel.text = "Most sheltered"
            }
            setSub(isHide: true)
        }
        timeLabel.text = route.getTime()
        disLabel.text = route.getDis()
        queueTimeLabel.attributedText = route.getWaitingString()
        setupInstructionView()
        var strOne = NSMutableAttributedString(string: "You will reach at: ", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.black])
        var strTwo = NSMutableAttributedString(string: route.getEstimatedTime(), attributes: [NSFontAttributeName: UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12)), NSForegroundColorAttributeName: UIColor.ospDarkGrey])
        strOne.append(strTwo)
        estimatedTimeLabel.attributedText = strOne
//
//        if route.type == "foot" {
//            iconView.isHidden = false
//            titleLabel.isHidden = false
//            disLabel.isHidden = false
//            busInstructionView.isHidden = true
//            arrivingTimeLabel.isHidden = true
//            queueTimeLabel.isHidden = true
//            disLabelTwo.isHidden = true
//            iconView.image = #imageLiteral(resourceName: "walking_big")
//            disLabel.text = route.getDis()
//            switch route.subType! {
//            case "fastest":
//                titleLabel.text = "Route costing the minimum time"
//            default:
//                titleLabel.text = "Route with the most shelters"
//            }
//        } else {
//            iconView.isHidden = true
//            titleLabel.isHidden = true
//            disLabel.isHidden = true
//            busInstructionView.isHidden = false
//            arrivingTimeLabel.isHidden = false
//            queueTimeLabel.isHidden = false
//            disLabelTwo.isHidden = false
//            disLabelTwo.text = route.getDis()
//            setupInstructionView()
//            queueTimeLabel.text = "Wait time: " + route.getWaitingTime()
//        }
    }
    
    func setupInstructionView() {
        for each in instructionView.subviews {
            each.snp.removeConstraints()
            each.removeFromSuperview()
        }
        instructionView.addSubview(startIcon)
        startIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Scale.scaleY(y: 16))
        }
        let firstArrow = UIImageView()
        firstArrow.applyBundleImage(name: "navigation_rightarrow")
        firstArrow.contentMode = .scaleAspectFit
        instructionView.addSubview(firstArrow)
        firstArrow.snp.makeConstraints { (make) in
            make.leading.equalTo(startIcon.snp.trailing).offset(Scale.scaleX(x: 6))
            make.centerY.equalTo(startIcon)
            make.height.equalTo(Scale.scaleY(y: 5))
            make.width.equalTo(Scale.scaleX(x: 6))
        }
        
        var subViews = [NavigationItemView]()
        var index = 0
        var firstPSV = true
        for each in (route?.PSVList)! {
            let itemView = NavigationItemView(type: FooyoConstants.transportationTypes[each])
            instructionView.addSubview(itemView)
            subViews.append(itemView)
            if firstPSV {
                firstPSV = false
                itemView.snp.makeConstraints { (make) in
                    make.leading.equalTo(firstArrow.snp.trailing).offset(Scale.scaleX(x: 9))
                    make.top.equalTo(subtitleTwoLabel.snp.bottom).offset(Scale.scaleY(y: 20))
                    make.height.equalTo(Scale.scaleY(y: 28))
                    make.width.equalTo(Scale.scaleX(x: 85))
                }
            } else {
                itemView.snp.makeConstraints { (make) in
                    make.leading.equalTo(subViews[index - 1].snp.trailing).offset(Scale.scaleX(x: 9))
                    make.top.equalTo(subtitleTwoLabel.snp.bottom).offset(Scale.scaleY(y: 20))
                    make.height.equalTo(Scale.scaleY(y: 28))
                    make.width.equalTo(Scale.scaleX(x: 85))
                }
            }
            index = index + 1
        }
        
        instructionView.addSubview(endIcon)
        endIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 14))
            make.width.equalTo(Scale.scaleY(y: 10))
            make.leading.equalTo(subViews[index - 1].snp.trailing).offset(Scale.scaleX(x: 9))
        }
    }
    static func estimateHeightWith(route: FooyoRoute) -> CGFloat {
        if (route.suggested)! {
            return Scale.scaleY(y: 194)
        } else {
            if route.type?.lowercased() == "bus" {
                return Scale.scaleY(y: 160)
            }
            return Scale.scaleY(y: 133)
        }
//        if route.type == "foot" {
//            let h1 = Scale.scaleY(y: 27)
//            let h2 = Scale.scaleY(y: 14)
//            let h3 = UILabel().heightForLabel("Route costing the minimum time", font: UIFont.DefaultRegularWithSize(size: 16), width: Constants.mainWidth - Scale.scaleX(x: 80) - Scale.scaleX(x: 44))
//            let h4 = Scale.scaleY(y: 4)
//            let h5 = UILabel().heightForLabel("test", font: UIFont.DefaultRegularWithSize(size: 14), width: Constants.mainWidth)
//            return h1 + 2 * h2 + h3 + h4 + h5
//        } else {
//            let h0 = Scale.scaleY(y: 27)
//            let h1 = Scale.scaleY(y: 10)
//            let h2 = Scale.scaleY(y: 24)
//            let h3 = Scale.scaleY(y: 17)
//            let h4 = Scale.scaleY(y: 11)
//            //            let h5 = Scale.scaleY(y: 5)
//            //            return h0 + 2 * h1 + h2 + h5 + 2 * h3 + h4
//            return h0 + 2 * h1 + h2 + h3 + h4
//        }
        return 50
    }
}
