//
//  RouteListTableViewCell.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 7/3/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "routeListTableViewCell"
    fileprivate var route: Route?
    var upperView: UIView! = {
        let t = UIView()
        t.backgroundColor = UIColor.sntWhiteTwo
        return t
    }()
    var catLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 12))
        t.textColor = UIColor.sntWarmGrey
        return t
    }()
    var lowerView: UIView! = {
        let t = UIView()
        t.backgroundColor = .clear
        return t
    }()
    var iconView: UIImageView! = {
        let t = UIImageView()
        t.contentMode = .center
        return t
    }()
    var titleLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.sntGreyishBrown
        t.numberOfLines = 0
        return t
    }()
    
    var disLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.sntWarmGrey
        return t
    }()
    var disLabelTwo: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        t.textColor = UIColor.sntWarmGrey
        return t
    }()
    var timeLabel: UILabel! = {
        let t = UILabel()
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 16))
        t.textColor = UIColor.sntGreyishBrown
        return t
    }()
    
    var busInstructionView: UIView! = {
        let t = UIView()
        t.backgroundColor  = .clear
        return t
    }()
    
    var arrivingTimeLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.sntWarmGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    
    var queueLabel: UILabel! = {
        let t = UILabel()
        //        t.layer.cornerRadius = Scale.scaleY(y: 3)
        //        t.clipsToBounds = true
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        //        t.layer.borderWidth = 1
        return t
    }()
    
    var queueTimeLabel: UILabel! = {
        let t = UILabel()
        t.textColor = UIColor.sntWarmGrey
        t.font = UIFont.DefaultRegularWithSize(size: Scale.scaleY(y: 14))
        return t
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        clipsToBounds = true
        layoutMargins = UIEdgeInsets.zero
        preservesSuperviewLayoutMargins = false
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(upperView)
        upperView.addSubview(catLabel)
        contentView.addSubview(lowerView)
        lowerView.addSubview(titleLabel)
        lowerView.addSubview(iconView)
        lowerView.addSubview(timeLabel)
        lowerView.addSubview(disLabel)
        lowerView.addSubview(disLabelTwo)
        lowerView.addSubview(busInstructionView)
        lowerView.addSubview(arrivingTimeLabel)
        lowerView.addSubview(queueLabel)
        lowerView.addSubview(queueTimeLabel)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        upperView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Scale.scaleY(y: 27))
        }
        catLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 18))
            make.centerY.equalToSuperview()
        }
        lowerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(upperView.snp.bottom)
        }
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Scale.scaleY(y: 32))
            make.leading.equalTo(Scale.scaleX(x: 8))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 44))
            make.trailing.equalTo(Scale.scaleX(x: -80))
            make.top.equalTo(Scale.scaleY(y: 14))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.trailing.equalTo(Scale.scaleX(x: -12))
        }
        disLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Scale.scaleY(y: 4))
            make.bottom.equalTo(Scale.scaleY(y: -14))
        }
        disLabelTwo.snp.makeConstraints { (make) in
            //            make.centerY.equalTo)
            make.bottom.equalTo(queueTimeLabel)
            make.trailing.equalTo(timeLabel)
        }
        busInstructionView.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 11))
            make.top.equalTo(Scale.scaleY(y: 10))
            make.height.equalTo(Scale.scaleY(y: 24))
            make.trailing.equalTo(Scale.scaleX(x: -80))
        }
        queueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(Scale.scaleX(x: 14))
            //            make.height.equalTo(Scale.scaleY(y: 23))
            make.height.equalTo(queueTimeLabel)
            make.centerY.equalTo(queueTimeLabel)
        }
        queueTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(queueLabel.snp.trailing).offset(Scale.scaleX(x: 5))
            make.top.equalTo(busInstructionView.snp.bottom).offset(Scale.scaleY(y: 10))
            make.height.equalTo(Scale.scaleY(y: 17))
            make.bottom.equalTo(Scale.scaleY(y: -11))
        }
        //        arrivingTimeLabel.snp.makeConstraints { (make) in
        //            make.leading.equalTo(Scale.scaleX(x: 14))
        //            make.top.equalTo(busInstructionView.snp.bottom).offset(Scale.scaleY(y: 10))
        //            make.height.equalTo(Scale.scaleY(y: 17))
        //        }
        //        queueTimeLabel.snp.makeConstraints { (make) in
        //            make.leading.equalTo(arrivingTimeLabel)
        //            make.top.equalTo(arrivingTimeLabel.snp.bottom).offset(Scale.scaleY(y: 5))
        //            make.bottom.equalTo(Scale.scaleY(y: -11))
        //            make.height.equalTo(Scale.scaleY(y: 17))
        //        }
        
    }
    func configureWith(route: Route) {
        self.route = route
        //        titleLabel.text = route.name
        timeLabel.text = route.getTime()
        switch route.subType! {
        case "fastest":
            catLabel.text = "FASTEST ROUTE"
        default:
            catLabel.text = "MOST SHELTERED"
        }
        if route.type == "foot" {
            iconView.isHidden = false
            titleLabel.isHidden = false
            disLabel.isHidden = false
            busInstructionView.isHidden = true
            arrivingTimeLabel.isHidden = true
            queueTimeLabel.isHidden = true
            disLabelTwo.isHidden = true
            iconView.image = #imageLiteral(resourceName: "walking_big")
            disLabel.text = route.getDis()
            switch route.subType! {
            case "fastest":
                titleLabel.text = "Route costing the minimum time"
            default:
                titleLabel.text = "Route with the most shelters"
            }
        } else {
            iconView.isHidden = true
            titleLabel.isHidden = true
            disLabel.isHidden = true
            busInstructionView.isHidden = false
            arrivingTimeLabel.isHidden = false
            queueTimeLabel.isHidden = false
            disLabelTwo.isHidden = false
            disLabelTwo.text = route.getDis()
            setupInstructionView()
            queueTimeLabel.text = "Wait time: " + route.getWaitingTime()
        }
    }
    
    func setupInstructionView() {
        for each in busInstructionView.subviews {
            each.snp.removeConstraints()
            each.removeFromSuperview()
        }
        var subViews = [UIView]()
        var index = 0
        var subIndex = 0
        var firstPSV = true
        for each in (route?.PSVList)! {
            if each == 0 {
                let view = UIImageView()
                view.image = #imageLiteral(resourceName: "walking")
                //                view.contentMode = .scaleAspectFit
                view.contentMode = .center
                busInstructionView.addSubview(view)
                subViews.append(view)
                view.snp.makeConstraints({ (make) in
                    make.height.equalTo(Scale.scaleY(y: 24))
                    make.width.equalTo(Scale.scaleX(x: 20))
                    make.centerY.equalToSuperview()
                    if index == 0 {
                        make.leading.equalToSuperview()
                    } else {
                        make.leading.equalTo(subViews[subIndex - 1].snp.trailing).offset(Scale.scaleX(x: 6))
                    }
                })
                subIndex += 1
            } else {
                if firstPSV {
                    firstPSV = false
                    //                    queueLabel.layer.borderColor = Constants.routeColor[each].cgColor
                    queueLabel.textColor = Constants.routeColor[each]
                    queueLabel.text = Constants.routeNames[each]
                }
                let view = UIImageView()
                view.image = #imageLiteral(resourceName: "bus")
                view.contentMode = .center
                busInstructionView.addSubview(view)
                subViews.append(view)
                
                let label = UILabel()
                label.layer.cornerRadius = Scale.scaleY(y: 3)
                label.clipsToBounds = true
                label.textColor = .white
                label.font = UIFont.DefaultBoldWithSize(size: Scale.scaleY(y: 13))
                label.text = Constants.routeNames[each]
                //                label.backgroundColor = UIColor.sntGreyishBrown
                label.backgroundColor = Constants.routeColor[each]
                
                busInstructionView.addSubview(label)
                subViews.append(label)
                view.snp.makeConstraints({ (make) in
                    make.height.width.equalTo(Scale.scaleY(y: 20))
                    make.centerY.equalToSuperview()
                    if index == 0 {
                        make.leading.equalToSuperview()
                    } else {
                        make.leading.equalTo(subViews[subIndex - 1].snp.trailing).offset(Scale.scaleX(x: 3))
                    }
                })
                subIndex += 1
                
                label.snp.makeConstraints({ (make) in
                    make.height.equalTo(Scale.scaleY(y: 23))
                    make.centerY.equalToSuperview()
                    if index == 0 {
                        make.leading.equalToSuperview()
                    } else {
                        make.leading.equalTo(subViews[subIndex - 1].snp.trailing).offset(Scale.scaleX(x: 3))
                    }
                })
                subIndex += 1
            }
            if index != (route?.PSVList?.count)! - 1 {
                let view = UIImageView()
                view.image = #imageLiteral(resourceName: "right_arrow")
                view.contentMode = .center
                busInstructionView.addSubview(view)
                subViews.append(view)
                view.snp.makeConstraints({ (make) in
                    make.height.equalToSuperview()
                    make.width.equalTo(Scale.scaleX(x: 8))
                    make.centerY.equalToSuperview()
                    make.leading.equalTo(subViews[subIndex - 1].snp.trailing).offset(Scale.scaleX(x: 3))
                })
                subIndex += 1
            }
            index += 1
        }
    }
    static func estimateHeightWith(route: Route) -> CGFloat {
        if route.type == "foot" {
            let h1 = Scale.scaleY(y: 27)
            let h2 = Scale.scaleY(y: 14)
            let h3 = UILabel().heightForLabel("Route costing the minimum time", font: UIFont.DefaultRegularWithSize(size: 16), width: Constants.mainWidth - Scale.scaleX(x: 80) - Scale.scaleX(x: 44))
            let h4 = Scale.scaleY(y: 4)
            let h5 = UILabel().heightForLabel("test", font: UIFont.DefaultRegularWithSize(size: 14), width: Constants.mainWidth)
            return h1 + 2 * h2 + h3 + h4 + h5
        } else {
            let h0 = Scale.scaleY(y: 27)
            let h1 = Scale.scaleY(y: 10)
            let h2 = Scale.scaleY(y: 24)
            let h3 = Scale.scaleY(y: 17)
            let h4 = Scale.scaleY(y: 11)
            //            let h5 = Scale.scaleY(y: 5)
            //            return h0 + 2 * h1 + h2 + h5 + 2 * h3 + h4
            return h0 + 2 * h1 + h2 + h3 + h4
        }
    }
}
