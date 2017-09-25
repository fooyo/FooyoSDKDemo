//
//  Bus.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 21/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class FooyoBus: BaseModel {
    var name: String?
    var queueTime: Int?
    var arriving: Int?
    
    init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
        queueTime = json["queue_time"].int
        arriving = json["next_arriving_time"].int
    }
    
    override init() {
        super.init()
    }
    
    func giveState() -> String {
        let state = "Wait time: \(queueTime!) min"
        return state
    }
    
    func getArrivingStatus() -> NSMutableAttributedString {
        if let time = arriving {
            if time == 0 {
                return NSMutableAttributedString(string: "Arriving", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11)), NSForegroundColorAttributeName: UIColor.ospSentosaGreen])
            }
            return NSMutableAttributedString(string: "\(time) mins", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11)), NSForegroundColorAttributeName: UIColor.ospGrey])
        }
        return NSMutableAttributedString(string: "Unavailable", attributes: [NSFontAttributeName: UIFont.DefaultSemiBoldWithSize(size: Scale.scaleY(y: 11)), NSForegroundColorAttributeName: UIColor.ospGrey])
    }
}
