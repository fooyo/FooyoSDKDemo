//
//  Instruction.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 29/3/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class FooyoInstruction: BaseModel {
    var routeNumber: Int?
    
    init(json: JSON) {
        super.init()
        routeNumber = json["route_number"].int
    }
    
    override init() {
        super.init()
    }

}
