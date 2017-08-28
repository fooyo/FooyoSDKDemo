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
    
    static var myItineraries = [FooyoItinerary]()
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
//    var routes: [FooyoRoute]?
//    var tickets: [Ticket]?
    
    var tripType: String?
    var warnings: [String]?
    
    init(json: JSON) {
        super.init()
        id = json["id"].int
        
        if json["places"] != nil {
            items = json["places"].arrayValue.map{ FooyoItem(json: $0) }
        }
//        if json["routes"] != nil {
//            routes = json["routes"].arrayValue.map{ FooyoRoute(json: $0) }
//        }
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
    
//    func getBounds() -> MGLCoordinateBounds {
//        
//        var swLat = Double((items?[0].coordinateLan)!)!
//        var swLon = Double((items?[0].coordinateLon)!)!
//        var neLat = Double((items?[0].coordinateLan)!)!
//        var neLon = Double((items?[0].coordinateLon)!)!
//        
//        for index in 1..<(items?.count)! {
//            let item = items![index]
//            if Double(item.coordinateLan!)! > neLat {
//                neLat = Double(item.coordinateLan!)!
//            } else if Double(item.coordinateLan!)! < swLat {
//                swLat = Double(item.coordinateLan!)!
//            }
//            if Double(item.coordinateLon!)! > neLon {
//                neLon = Double(item.coordinateLon!)!
//            } else if Double(item.coordinateLon!)! < swLon {
//                swLon = Double(item.coordinateLon!)!
//            }
//        }
//        
//        return MGLCoordinateBounds(sw: CLLocationCoordinate2DMake(swLat, swLon), ne: CLLocationCoordinate2DMake(neLat, neLon))
//    }
//    
//    func makeCopy() -> Itinerary {
//        let t = Itinerary()
//        t.id = id
//        t.time = time
//        t.budget = budget
//        t.theme = theme
//        t.name = name
//        t.items = items
//        t.routes = routes
//        t.tickets = tickets
//        t.tripType = tripType
//        return t
//    }
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
//    class func sort() {
//        self.past = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == -1// > 0
//        })
//        self.future = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == 1
//        })
//        self.today = Itinerary.myItineraries.filter({ (itinerary) -> Bool in
//            let check = DateTimeTool.compare(date: Date(), dateString: (itinerary.time)!)
//            return check == 0
//        })
//        self.todayAndFuture = [Itinerary]()
//        self.todayAndFuture.append(contentsOf: self.today)
//        self.todayAndFuture.append(contentsOf: self.future)
//    }
//    
//    class func update(itineraty: Itinerary) {
//        for index in 0..<Itinerary.myItineraries.count {
//            let iti = Itinerary.myItineraries[index]
//            if iti.id == itineraty.id {
//                Itinerary.myItineraries[index] = itineraty.makeCopy()
//                return
//            }
//        }
//    }
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
}
