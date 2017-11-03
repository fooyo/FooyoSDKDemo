//
//  Itinerary.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 15/4/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import Foundation
import Mapbox
import SwiftyJSON

class FooyoItinerary: BaseModel {
    
    static var newItinerary = FooyoItinerary()
    
    static var myItineraries: [FooyoItinerary]?
    
    static var past = [FooyoItinerary]()
    static var today = [FooyoItinerary]()
    static var future = [FooyoItinerary]()
    static var todayAndFuture = [FooyoItinerary]()
    
    static var todaySelected: FooyoItinerary?
    static var nextDestination: FooyoItem?
    
    var time: String?
    var budget: Double?
    var theme: String?
    var name: String?
    var items: [FooyoItem]?
    var routes: [FooyoRoute]?
//    var tickets: []?
    
    var tripType: String?
    var warnings: [String]?
    
    init(json: JSON) {
        super.init()
        id = json["id"].int
        
        if json["places"] != nil {
            items = json["places"].arrayValue.map{ FooyoItem(json: $0) }
        }
        if json["routes"] != nil {
            routes = json["routes"].arrayValue.map{ FooyoRoute(json: $0) }
        }
        name = json["name"].string
        time = json["trip_start_time"].string
        if json["budget"].double != nil {
            budget = json["budget"].double
        } else if json["budget"].string != nil {
            let str = json["budget"].string
            budget = Double(str!)
        }
        debugPrint("the budget is \(budget)")
        tripType = json["trip_type"].string
        warnings = json["warnings"].arrayValue.map{ $0.string! }
//        generateTickets()
    }
    
    override init() {
        super.init()
    }
    
    func getBounds() -> MGLCoordinateBounds {
        
        var swLat = items![0].coordinateLan!
        var swLon = items![0].coordinateLon!
        var neLat = items![0].coordinateLan!
        var neLon = items![0].coordinateLon!
        
        for index in 1..<(items?.count)! {
            let item = items![index]
            if item.coordinateLan! > neLat {
                neLat = item.coordinateLan!
            } else if item.coordinateLan! < swLat {
                swLat = item.coordinateLan!
            }
            if item.coordinateLon! > neLon {
                neLon = item.coordinateLon!
            } else if item.coordinateLon! < swLon {
                swLon = item.coordinateLon!
            }
        }
        
        return MGLCoordinateBounds(sw: CLLocationCoordinate2DMake(swLat, swLon), ne: CLLocationCoordinate2DMake(neLat, neLon))
    }
//
    func makeCopy() -> FooyoItinerary {
        let t = FooyoItinerary()
        t.id = id
        t.time = time
        t.budget = budget
        t.theme = theme
        t.name = name
        t.items = items
        t.routes = routes
        t.tripType = tripType
        return t
    }
//
//    func generateTickets() {
//        for index in 0 ..< ((items?.count)!) {
//            let item = self.items?[index]
//            if item?.category == "attraction" || item?.category == "show" || item?.category == "restaurant" {
//                if item?.budget != 0 {
//                    let ticket = Ticket()
//                    ticket.time = item?.arrivingTime
//                    ticket.item = item
//                    ticket.pax = 1
//                    ticket.price = item?.budget
//                    if self.tickets == nil {
//                        self.tickets = [ticket]
//                    } else {
//                        self.tickets?.append(ticket)
//                    }
//                }
//            }
//        }
//    }
//    
    class func sort() {
        if let myItineraries = FooyoItinerary.myItineraries {
            self.past = myItineraries.filter({ (itinerary) -> Bool in
                let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
                return check == -1// > 0
            })
            self.future = myItineraries.filter({ (itinerary) -> Bool in
                let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
                return check == 1
            })
            self.today = myItineraries.filter({ (itinerary) -> Bool in
                let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
                return check == 0
            })
        }
        self.todayAndFuture = [FooyoItinerary]()
        self.todayAndFuture.append(contentsOf: self.today)
        self.todayAndFuture.append(contentsOf: self.future)
    }
//
    func getSummaryTag() -> String {
//        17 Jun 2001  6 Places • $100–300/pax
        var tag = ""
        if let time = self.time {
            tag += DateTimeTool.fromFormatThreeToFormatSeven(date: time)
        }
        tag += " • "
        if let items = items {
            tag += "\(items.count) Places"
        }
        tag += " • "
        if let budget = budget {
            switch budget {
            case 50:
                tag += "Less than $50/pax"
            case 100:
                tag += "$50-150/pax"
            default:
                tag += "$150 and above/pax"
            }
        }
        return tag
    }
    
    class func update(itineraty: FooyoItinerary) {
        if let myItineraries = FooyoItinerary.myItineraries {
            for index in 0..<myItineraries.count {
                let iti = myItineraries[index]
                if iti.id == itineraty.id {
                    debugPrint("found the same")
                    FooyoItinerary.myItineraries?[index] = itineraty
                    return
                }
            }
        }
    }
//
//    func itemExists(item: Item) -> Bool {
//        if let items = items {
//            for each in items {
//                if each.id == item.id {
//                    return true
//                }
//            }
//        }
//        return false
//    }
    
    func updateItems() {
        if FooyoItem.items.count > 0 {
            if items != nil {
                for index in 0..<items!.count {
                    for a in FooyoItem.items {
                        if items![index].id == a.id {
                            a.arrivingTime = items![index].arrivingTime
                            items![index] = a
                            break
                        }
                    }
                }
            }
        }
    }
}
