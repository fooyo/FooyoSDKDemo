//
//  MyCustomPointAnnotation.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 23/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox

class MyCustomPointAnnotation: MGLPointAnnotation {
//    var coverImage: String?
//    var state: String?
//    var id: Int?
    var item: FooyoItem?
    var reuseId: String?
    var index: Int? // for itinerary
    var scaled = false
    var isInSelectedCatrgory = true
    var isHidden = false

    func aCopy() -> MyCustomPointAnnotation {
        let t = MyCustomPointAnnotation()
        t.index = self.index
        t.item = self.item
        t.title = self.title
        t.coordinate = self.coordinate
        // may have error
        t.reuseId = self.reuseId
        return t
    }
}
