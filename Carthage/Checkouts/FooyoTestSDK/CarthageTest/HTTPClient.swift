////
////  HTTPClient.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 23/2/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
import UIKit
import Alamofire
import SwiftyJSON
import Mapbox
//
//
protocol HttpClientDelegte: class {
    func alertMessage(title: String, message: String)
//    func logout()
}
//

public class HttpClient: NSObject {
    static let sharedInstance = HttpClient()
    weak var delegate: HttpClientDelegte?
    
    // MARK: - Items
    func getItems(completion: @escaping (_ items: [FooyoItem]?, _ isSuccess: Bool) -> Void) {
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/places", method: .get, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["places"] != nil {
                        var items = [FooyoItem]()
                        items = data["places"].arrayValue.map{ FooyoItem(json: $0) }
                        FooyoItem.items = items
                        if let vivo = items.first(where: { (item) -> Bool in
                            return (item.name!.lowercased().contains("vivo")) && (item.name!.lowercased().contains("city")) || (item.name!.lowercased().contains("sentosa station"))
                        }){
                            FooyoItem.vivo = vivo
                        }
                        completion(items, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    func getCategories(completion: @escaping (_ categories: [FooyoCategory]?, _ isSuccess: Bool) -> Void) {
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/categories", method: .get, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["categories"] != nil {
                        var categories = [FooyoCategory]()
                        var amenities = [FooyoCategory]()
                        var transportations = [FooyoCategory]()
                        var others = [FooyoCategory]()
                        
                        categories = data["categories"].arrayValue.map{ FooyoCategory(json: $0) }
                        amenities = categories.filter({ (category) -> Bool in
                            return category.isAmenity == true
                        })
                        transportations = categories.filter({ (category) -> Bool in
                            return category.isTransportation == true
                        })
                        others = categories.filter({ (category) -> Bool in
                            if (category.name?.lowercased().contains("f&b"))! {
                                return false
                            }
                            if (category.name?.lowercased().contains("hotel"))! {
                                return false
                            }
                            if (category.name?.lowercased().contains("retail"))! {
                                return false
                            }
                            return category.isAmenity == false && category.isTransportation == false
                        })
                        
                        FooyoCategory.categories = categories
                        FooyoCategory.others = others
                        FooyoCategory.amenities = amenities
                        FooyoCategory.transportations = transportations
                        
                        completion(categories, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    // MARK: - Navigation
    func findNavigationFor(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, completion: @escaping (_ routes: [FooyoRoute]?, _ isSuccess: Bool) -> Void) {
        let startLat = start.latitude
        let startLon = start.longitude
        let endLat = end.latitude
        let endLon = end.longitude
        let url = "\(FooyoConstants.EndPoint.baseURL)/routes?point[]=\(startLat)%2C\(startLon)&point[]=\(endLat)%2C\(endLon)"
        debugPrint(url)
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["routes"] != nil {
                        var routes = [FooyoRoute]()
                        routes = data["routes"].arrayValue.map{ FooyoRoute(json: $0) }
                        completion(routes, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    // MARK: - Itinerary
    func optimizeRoute(start: Int, all: [Int], keep: Bool = false, type: String, budget: Double, time: String, completion: @escaping (_ itinerary: FooyoItinerary?, _ isSuccess: Bool) -> Void) {
        var params = [String: [String: Any]]()
        debugPrint("i am going to test here")
        if keep {
            params = [
                "itinerary": [
                    "no_order_change": keep,
                    "start_place_id": start,
                    "place_ids": all,
                    "budget": budget,
                    "trip_type": type,
                    "start_time": time
                ]
            ]
        } else {
            params = [
                "itinerary": [
                    "start_place_id": start,
                    "place_ids": all,
                    "budget": budget,
                    "trip_type": type,
                    "start_time": time
                ]
            ]
        }
        debugPrint(params)
        debugPrint("\(FooyoConstants.EndPoint.baseURL)/itineraries/build")
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/itineraries/build", method: .post, parameters: params).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["itinerary"] != nil {
                        let itinerary = FooyoItinerary(json: data["itinerary"])
                        completion(itinerary, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    func createItinerary(startId: Int, allId: [Int], start: String, name: String, budget: Double, type: String, completion: @escaping (_ itinerary: FooyoItinerary?, _ isSuccess: Bool) -> Void) {
        let params: [String: [String: Any]] = [
            "itinerary": [
                "start_place_id": startId,
                "place_ids": allId,
                "start_time": start,
                "name": name,
                "budget": budget,
                "trip_type": type,
                "user_id": FooyoUser.currentUser.userId!
            ]
        ]
        debugPrint(params)
        debugPrint("\(FooyoConstants.EndPoint.baseURL)/itineraries")
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/itineraries", method: .post, parameters: params).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["itinerary"] != nil {
                        let itinerary = FooyoItinerary(json: data["itinerary"])
                        completion(itinerary, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    func getItineraries(completion: @escaping (_ itineraries: [FooyoItinerary]?, _ isSuccess: Bool) -> Void) {
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/itineraries?user_id=\(FooyoUser.currentUser.userId!)", method: .get).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["itineraries"] != nil {
                        let itineraries = data["itineraries"].arrayValue.map{ FooyoItinerary(json: $0) }
                        FooyoItinerary.myItineraries = itineraries
                        FooyoItinerary.sort()
                        self.PostItineraryDownloadedNotification()
                        completion(itineraries, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    func getItinerary(id: Int, completion: @escaping (_ itinerary: FooyoItinerary?, _ isSuccess: Bool) -> Void) {
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/itineraries/\(id)", method: .get).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["itinerary"] != nil {
                        let itinerary = FooyoItinerary(json: data["itinerary"])
                        completion(itinerary, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
    
    func updateItinerary(id: Int, allId: [Int], name: String, type: String, completion: @escaping (_ itinerary: FooyoItinerary?, _ isSuccess: Bool) -> Void) {
        let params: [String: [String: Any]] = [
            "itinerary": [
                "place_ids": allId,
                "name": name
            ]
        ]
        debugPrint(params)
        Alamofire.request("\(FooyoConstants.EndPoint.baseURL)/itineraries/\(id)", method: .put, parameters: params).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["itinerary"] != nil {
                        let itinerary = FooyoItinerary(json: data["itinerary"])
                        completion(itinerary, true)
                        return
                    }
                }
            } else {
                if let json = response.result.value {
                    if let json = json as? [String: AnyObject] {
                        if let errors = json["errors"] as? [String] {
                            if errors.count != 0 {
                                self.delegate?.alertMessage(title: "Error Message", message: errors[0])
                            }
                        }
                    }
                }
            }
            completion(nil, false)
        }
    }
}
