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
    var budget: Double?
    var coverImages: String?
    var coordinateLan: Double?
    var coordinateLon: Double?
    var levelOneId: String?
    var levelTwoId: String?
    var region: String?
    var rating: String?
    var trailName: String?
    
    var arrivingTime: String?
    var visitingTime: Int?
    var lowBudgetVisitingTime: Int?
    var themes: [FooyoTheme]?

    public init(json: JSON) {
        super.init()
        id = json["id"].int
        name = json["name"].string
        operation = json["operation_hours"].string
        if json["category"] != nil {
            category = FooyoCategory(json: json["category"])
        }
        budget = json["budget"].double
        coordinateLan = json["lat"].double
        coordinateLon = json["lng"].double
        coverImages = json["thumbnail"].string
        levelOneId = json["level_one_id"].string
        if levelOneId == nil {
            if let id = json["level_one_id"].int {
                levelOneId = String(describing: id)
            }
        }
        levelTwoId = json["level_two_id"].string
        if levelTwoId == nil {
            if let id = json["level_two_id"].int {
                levelTwoId = String(describing: id)
            }
        }
        rating = json["rating"].string
        region = json["region"].string
        trailName = json["ldr_trail_name"].string
        
        
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
        case "attractions", "events":
            return parseOptionalString(input: region, defaultValue: "Pending") + " • \(parseOptionalString(input: category?.name))"
        case "Interactive Trails".lowercased():
            if isNonLinearHotspot() {
                return "Belongs to #\(parseOptionalString(input: trailName, defaultValue: "Pending"))"
            } else {
                return parseOptionalString(input: region, defaultValue: "Pending") + " • \(parseOptionalString(input: category?.name))"
            }
        default:
            return "Pending"
        }
    }
    
    func getCoor() -> CLLocationCoordinate2D {
        let lat = self.coordinateLan!
        let lon = self.coordinateLon!
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func getLowBudgetVisitingTime() -> String {
        if lowBudgetVisitingTime! < 60 {
            return "\(String(describing: self.lowBudgetVisitingTime!)) mins"
        } else if lowBudgetVisitingTime! < 120 {
            let mins = lowBudgetVisitingTime! - 60
            if mins > 0 {
                return "1 hr \(String(mins)) mins"
            } else {
                return "1 hr"
            }
        } else {
            let mins = lowBudgetVisitingTime! - 120
            if mins > 0 {
                return "2 hr \(String(mins)) mins"
            } else {
                return "2 hr"
            }
        }
    }
    
    func getVisitingTime() -> String {
        if visitingTime! < 60 {
            return "\(String(describing: self.visitingTime!)) mins"
        } else {
            let mins = visitingTime! - 60
            if mins > 0 {
                return "1 hr \(String(mins)) mins"
            } else {
                return "1 hr"
            }
        }
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
        if let time = arrivingTime {
            return DateTimeTool.fromFormatThreeToFormatFour(date: time)
        }
        return ""
    }
    
    class func findMatch(index: FooyoIndex) -> FooyoItem {
        var item = FooyoItem()
        if index.isNonLinearTrailHotspot() {
            item = FooyoItem.items.first(where: { (a) -> Bool in
                let checkOne = index.category == a.category?.name
                let checkTwo = index.levelOneId == a.levelOneId
                let checkThree = index.levelTwoId == a.levelTwoId
                return checkOne && checkTwo && checkThree
            })!
        } else {
            item = FooyoItem.items.first(where: { (a) -> Bool in
                let checkOne = index.category == a.category?.name
                let checkTwo = index.levelOneId == a.levelOneId
                return checkOne && checkTwo
            })!
        }
        return item
    }
    
    func isEssential() -> Bool {
        switch (category?.name)! {
        case "Prayer Rooms", "Ticketing Counters", "Rest Rooms", "Bus Stops", "Tram Stops", "Cable Car Stations", "Express Stations", "Nursing Room", "Taxi Stand":
            return false
        default:
            return true
        }
    }
}
