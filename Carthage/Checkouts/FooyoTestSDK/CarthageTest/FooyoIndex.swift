//
//  FooyoIndex.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 30/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

public class FooyoIndex: NSObject {
    public var category: String?
    public var levelOneId: Int?
    public var levelTwoId: Int?
    
    public init(category: String) {
        super.init()
        self.category = category
    }
    public init(category: String, levelOneId: Int) {
        super.init()
        self.category = category
        self.levelOneId = levelOneId
    }
    public init(category: String, levelOneId: Int, levelTwoId: Int) {
        super.init()
        self.category = category
        self.levelOneId = levelOneId
        self.levelTwoId = levelTwoId
    }
}
