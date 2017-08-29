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
    
    
    init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
        queueTime = json["queue_time"].int
    }
    
    override init() {
        super.init()
    }
    
    func giveState() -> String {
        let state = "Wait time: \(queueTime!) min"
        return state
    }    
}
