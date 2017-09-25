//
//  ACCNUser.swift
//  FooyoSDKTest
//
//  Created by Yangfan Liu on 25/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class ACCNUser: NSObject {
    static var currentUser = ACCNUser()
    
    var userId: String?
    
    override init() {
        super.init()
    }

}
