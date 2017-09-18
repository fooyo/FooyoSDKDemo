//
//  Category.swift
//  CarthageTest
//
//  Created by Yangfan Liu on 21/8/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Mapbox
//import DateToolsSwift

public class FooyoCategory: BaseModel {
    
    static var categories = [FooyoCategory]()
    static var others = [FooyoCategory]()
    static var amenities = [FooyoCategory]()
    static var transportations = [FooyoCategory]()

    var name: String?
    var color: String?
    var icon: String?
    var isAmenity: Bool?// = false
    var isTransportation: Bool?// = false

    //    var cat
    public init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
        color = json["color"].string
        icon = json["icon"].string
        isAmenity = json["is_amenity"].bool
        isTransportation = json["is_transportation"].bool
        if isTransportation == nil {
            if (name?.lowercased().contains("stop"))! || (name?.lowercased().contains("station"))! {
                isTransportation = true
            } else {
                isTransportation = false
            }
        }
    }
    
    override public init() {
        super.init()
    }
    
    func getColor() -> UIColor {
//        return UIColor(rgb: Int!)
        if (self.color)! == "ffffff" {
            return UIColor.ospGrey
        }
        return UIColor(hexString: "0x" + (self.color)!)
    }
}
