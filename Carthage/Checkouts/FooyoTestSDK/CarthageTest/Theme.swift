//
//  Theme.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 5/6/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class FooyoTheme: BaseModel {
    var name: String?
    
    init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
    }
    
    override init() {
        super.init()
    }

}
