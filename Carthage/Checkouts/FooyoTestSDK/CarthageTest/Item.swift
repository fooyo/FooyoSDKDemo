//
//  Item.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 21/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON
import Mapbox
//import DateToolsSwift

public class FooyoItem: BaseModel {
    
    static var items = [FooyoItem]()
    static var vivo = FooyoItem()

    var name: String?
    var category: FooyoCategory?
    var operation: String?
    var gettingThere: String?
    var carpark: String?

    var budget: Double?
    var coverImages: String?
    var coordinateLan: Double?
    var coordinateLon: Double?
    var levelOneId: String?
    var levelTwoId: String?
    var region: String?
    var rating: Double?
    var trailName: String?
    var trailImage: String?
    
    var arrivingTime: String?
    var visitingTime: Int?
    var lowBudgetVisitingTime: Int?
    var themes: [FooyoTheme]?
    var buses: [FooyoBus]?
    
    var isInEditMode: Bool? = false
    
    public init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
        operation = json["operation_hours"].string
        gettingThere = json["getting_there"].string
        carpark = json["nearest_carpark"].string

        if json["category"] != nil {
            category = FooyoCategory(json: json["category"])
        }
        if json["buses"] != nil {
            buses = json["buses"].arrayValue.map{ FooyoBus(json: $0) }
        }
        
        budget = json["budget"].double
        
        if budget == nil {
            budget = 15
        }
        
        coordinateLan = json["lat"].double
        coordinateLon = json["lng"].double
        coverImages = json["thumbnail"].string
        levelOneId = json["level_one_id"].string
        if levelOneId == nil {
            if let id = json["level_one_id"].int {
                levelOneId = String(describing: id)
            }
        }
        if levelOneId == nil {
            levelOneId = "\(id!)"
        }
        levelTwoId = json["level_two_id"].string
        if levelTwoId == nil {
            if let id = json["level_two_id"].int {
                levelTwoId = String(describing: id)
            }
        }
        rating = json["rating"].double
        region = json["region"].string
        trailName = json["ldr_trail_name"].string
        trailImage = json["ldr_trail_thumbnail"].string

        arrivingTime = json["arriving_time"].string
        visitingTime = json["visiting_time"].int
        lowBudgetVisitingTime = json["low_budget_visiting_time"].int

    }
    
    override public init() {
        super.init()
    }
    
    func isNonLinearHotspot() -> Bool {
        if levelTwoId == nil {
            return false
        }
        return true
    }
    
    func findBrothers() -> [FooyoItem] {
        let items = FooyoItem.items.filter({ (a) -> Bool in
            return self.levelOneId == a.levelOneId && self.category?.id == a.category?.id
        })
        return items
    }
    
    func getTag() -> String {
        switch (category?.name?.lowercased())! {
        case FooyoConstants.CategoryName.Attractions.rawValue.lowercased(), FooyoConstants.CategoryName.Events.rawValue.lowercased():
            return parseOptionalString(input: region, defaultValue: "") + " • \(parseOptionalString(input: category?.name))"
        case FooyoConstants.CategoryName.Trails.rawValue.lowercased():
            if isNonLinearHotspot() {
                return "Belongs to #\(parseOptionalString(input: trailName, defaultValue: ""))"
            } else {
                return parseOptionalString(input: region, defaultValue: "") + " • \(parseOptionalString(input: category?.name))"
            }
        default:
            return parseOptionalString(input: region, defaultValue: "")
        }
    }
    
    func getCoor() -> CLLocationCoordinate2D {
        let lat = self.coordinateLan!
        let lon = self.coordinateLon!
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func getLowBudgetVisitingTime() -> String {
        if let time = lowBudgetVisitingTime {
            let hour = time / 60
            let min = time % 60
            if hour > 0 {
                if min > 0 {
                    return "\(hour) hrs \(min) mins"
                } else {
                    return "\(hour) hrs"
                }
            } else {
                return "\(min) mins"
            }
        }
        return "Unavailable"
    }
    
    func getVisitingTime() -> String {
        if let time = visitingTime {
            let hour = time / 60
            let min = time % 60
            if hour > 0 {
                if min > 0 {
                    return "\(hour) hrs \(min) mins"
                } else {
                    return "\(hour) hrs"
                }
            } else {
                return "\(min) mins"
            }
        }
        return "Unavailable"
    }
    
    func belongsToTheme(theme: String?) -> Bool {
        if let theme = theme {
            if let themes = themes {
                for each in themes {
                    if each.name!.lowercased() == theme.lowercased() {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func getDuration() -> String {
        if let time = arrivingTime, let visiting = visitingTime {
            let arrivalDate = DateTimeTool.fromFormatThreeToDate(time)
//            let leaveDate = arrivalDate.mins
            let calendar = Calendar.current
            let leaveDate = calendar.date(byAdding: .minute, value: visiting, to: arrivalDate)!
            return DateTimeTool.fromFormatThreeToFormatFour(date: time) + " - " + DateTimeTool.fromDateToFormatFour(date: leaveDate)
        }
        return ""
    }
    
    func getArrivalTime() -> String {
        if let time = arrivingTime {
            return DateTimeTool.fromFormatThreeToFormatFour(date: time)
        }
        return ""
    }
    
    class func findMatch(index: FooyoIndex) -> [FooyoItem]? {
//        debugPrint("")
        debugPrint(index.category)
        debugPrint(index.levelOneId)
        var items = [FooyoItem]()
        items = FooyoItem.items.filter({ (item) -> Bool in
            let checkOne = index.category == item.category?.name
            let checkTwo = index.levelOneId == item.levelOneId
            return checkOne && checkTwo
        })
        if items.count == 0 {
            debugPrint("no match")
            return nil
        }
        debugPrint(items.count)
        debugPrint(items[0].name)
        return items
    }
    
    func isEssential() -> Bool {
        switch (category?.name)! {
        case FooyoConstants.CategoryName.Attractions.rawValue, FooyoConstants.CategoryName.Events.rawValue, FooyoConstants.CategoryName.Trails.rawValue:
            return true
        default:
            return false
        }
    }
    
    func makeCopy() -> FooyoItem {
        let t = FooyoItem()
        t.id = self.id
        t.name = self.name
        return t
    }
    
    func getRatingStr() -> String {
        if let rating = rating {
            return "\(rating)" + "/5"
        }
        return ""
    }
    
    func getFooyoIndex() -> FooyoIndex {
        let index = FooyoIndex(category: self.category?.name, levelOneId: self.levelOneId, levelTwoId: self.levelTwoId)
        return index
    }
}
