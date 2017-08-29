////
////  Route.swift
////  SmartSentosa
////
////  Created by Yangfan Liu on 7/3/17.
////  Copyright © 2017 Yangfan Liu. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import Mapbox
//
//class FooyoRoute: BaseModel {
//    var name: String?
//    
//    var type: String?
//    var subType: String?
//    
//    var waitingTime: Int?
//    var timeSummary: Int?
//    var distanceSummary: Double?
//    
//    var bbox: [Double]?
//    
//    var startCoord: CLLocationCoordinate2D?
//    var endCoord: CLLocationCoordinate2D?
//    var startItem: FooyoItem?
//    var endItem: FooyoItem?
//    
//    var suggested: Bool?
//    
//    var instructions: [FooyoInstruction]?
//    var coordinates: [[Double]]?
//    var coordList: [[[Double]]]?
//    var typeList: [Constants.RouteType]?
//    
//    var PSVList: [Int]?
////    
//    init(json: JSON) {
//        super.init()
//        type = json["meta"]["vehicle"].string
//        subType = json["meta"]["weighting"].string
//        suggested = json["meta"]["suggested"].bool
//        waitingTime = json["meta"]["queue_time"].int
//        timeSummary = json["paths"][0]["time"].int
//        distanceSummary = json["paths"][0]["distance"].double
//        bbox = json["paths"][0]["bbox"].arrayValue.map{ $0.double! }
//        coordinates = json["paths"][0]["points"]["coordinates"].arrayValue.map{ $0.arrayValue.map{ $0.double! } }
//        instructions = json["paths"][0]["instructions"].arrayValue.map{ FooyoInstruction(json: $0) }
////        splitPoints()
////        splitPSV()
//    }
////
//    override init() {
//        super.init()
//    }
////    
////    //    func getWaitingMins() -> Int {
////    //        return Int(ceil(Double(waitingTime!) / 60000.0))
////    //    }
////    func getWaitingTime() -> String {
////        if waitingTime == nil || waitingTime == 0 {
//////            let randomNum:UInt32 = arc4random_uniform(25) // range is 0 to 99
//////            let someInt:Int = Int(randomNum)
//////            let time = someInt + 5
////            return "1 mins"
////        }
////        return "\(waitingTime!) mins"
////    }
////    
////    func getMins() -> Int {
////        return Int(ceil(Double(timeSummary!) / 60000.0))
////    }
////    func getTime() -> String {
////        return String(getMins()) + " mins"
////    }
////    func getTimeInTwoLines() -> String {
////        return String(getMins()) + "\nmins"
////    }
////    func getDis() -> String {
////        if distanceSummary! > 1000 {
////            let km = Scale.roundToPlaces(value: CGFloat(distanceSummary!) / 1000.0, places: 1)
////            return "\(Double(km))" + " km"
////        }
////        return "\(distanceSummary!)" + " m"
////    }
////    
////    func getBounds() -> MGLCoordinateBounds {
////        let swLat = self.bbox![1]
////        let swLon = self.bbox![0]
////        let neLat = self.bbox![3]
////        let neLon = self.bbox![2]
////        return MGLCoordinateBounds(sw: CLLocationCoordinate2DMake(swLat, swLon), ne: CLLocationCoordinate2DMake(neLat, neLon))
////    }
////    
////    func getName() -> String {
////        if self.subType != nil {
////            switch self.subType! {
////            case "fastest":
////                return "FASTEST ROUTE"
////            default:
////                return "MOST SHELTERED"
////            }
////        } else {
////            return "Detailed Navigation"
////        }
////    }
////    
////    func splitPoints() {
////        if type == "bus" {
////            var isWalking = true
////            if let coordinates = coordinates {
////                var list = [[Double]]()
////                var type: Double = -1
////                let first = coordinates[0]
////                type = first[2]
////                if type == 1 {
////                    isWalking = false
////                }
////                let point = [first[0], first[1]]
////                list.append(point)
////                
////                for index in 1..<coordinates.count {
////                    let each = coordinates[index]
////                    if each[2] == type {
////                        let point = [each[0], each[1]]
////                        list.append(point)
////                    } else {
////                        if type == 0 {
////                            if typeList == nil {
////                                typeList = [.Walking]
////                            } else {
////                                typeList?.append(.Walking)
////                            }
////                        } else {
////                            if typeList == nil {
////                                typeList = [.PSV]
////                            } else {
////                                typeList?.append(.PSV)
////                            }
////                        }
////                        if coordList == nil {
////                            coordList = [list]
////                        } else {
////                            coordList?.append(list)
////                        }
////                        
////                        type = each[2]
////                        if type == 1 {
////                            isWalking = false
////                        }
////                        list = [[Double]]()
////                        let point = [each[0], each[1]]
////                        list.append(point)
////                    }
////                    if index == coordinates.count - 1 {
////                        if type == 0 {
////                            if typeList == nil {
////                                typeList = [.Walking]
////                            } else {
////                                typeList?.append(.Walking)
////                            }
////                        } else {
////                            if typeList == nil {
////                                typeList = [.PSV]
////                            } else {
////                                typeList?.append(.PSV)
////                            }
////                        }
////                        if coordList == nil {
////                            coordList = [list]
////                        } else {
////                            coordList?.append(list)
////                        }
////                    }
////                }
////            }
////            if (coordList?.count)! > 1 {
////                if let list = coordList {
////                    for index in 1..<list.count {
////                        let cur = list[index]
////                        let point = cur[0]
////                        self.coordList![index - 1].append(point)
////                    }
////                }
////            }
////            if isWalking {
////                type = "walking"
////            }
////        }
////    }
////    
////    func splitPSV() {
////        if type == "bus" {
////            var tmpPSV = 0
////            PSVList = [tmpPSV]
////            if let ins = instructions {
////                for each in ins {
////                    if each.routeNumber != tmpPSV {
////                        PSVList?.append(each.routeNumber!)
////                        tmpPSV = each.routeNumber!
////                    }
////                }
////            }
////        }
////    }
//    
//}
