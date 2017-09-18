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
    public var levelOneId: String?
    public var levelTwoId: String?
    
    public init(category: String) {
        super.init()
        self.category = category
    }
    public init(category: String, levelOneId: String) {
        super.init()
        self.category = category
        self.levelOneId = levelOneId
    }
    public init(category: String, levelOneId: String, levelTwoId: String) {
        super.init()
        self.category = category
        self.levelOneId = levelOneId
        self.levelTwoId = levelTwoId
    }
    func isNonLinearTrailHotspot() -> Bool {
        if levelTwoId != nil {
            return true
        }
        return false
    }
    func isCategory() -> Bool {
        if levelOneId == nil {
            return true
        }
        return false
    }
    func isLocation() -> Bool {
        if levelOneId != nil {
            return true
        }
        return false
    }
}
