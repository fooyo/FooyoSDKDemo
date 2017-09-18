//
//  Constant.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 21/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox

struct FooyoConstants {
    
    struct EndPoint {
        #if DEBUG
        static let baseURL = "https://sentosa-api.fooyo.sg/v1"
        //            static let baseURL = "http://54.169.237.216/v1"
        //            static let baseURL = "https://api.travbook.me/v1"
        #else
        static let baseURL = "https://sentosa-api.fooyo.sg/v1"
        //            static let baseURL = "https://api.travbook.me/v1"
        //            static let baseURL = "http://54.169.237.216/v1"
        #endif
    }
    
    static let statusBarHeight: CGFloat = 20
    static let navigationBarHeight: CGFloat = 44
    static let mainWidth: CGFloat = UIScreen.main.bounds.width
    static let mainHeight: CGFloat = UIScreen.main.bounds.height
    static let imageLoadTime: Double = 0.2
    static let mapCenterLat: Double = 1.254585
    static let mapCenterLong: Double = 103.822706
    static let initZoomLevel: Double = 13
    static let mapBound = [CLLocationCoordinate2DMake(1.265713, 103.819852),
                           CLLocationCoordinate2DMake(1.260715, 103.819691),
                           CLLocationCoordinate2DMake(1.260704, 103.805111),
                           CLLocationCoordinate2DMake(1.236098, 103.804682),
                           CLLocationCoordinate2DMake(1.236357, 103.852152),
                           CLLocationCoordinate2DMake(1.267034, 103.851047)]
    static let vivoLocation = CLLocationCoordinate2DMake(1.264032, 103.822292)
    
    
    struct notifications {
        static let FooyoDisplayAlert = Notification.Name("FooyoDisplayAlert")
        static let FooyoUpdateHistory = Notification.Name("FooyoUpdateHistory")
        static let FooyoSearch = Notification.Name("FooyoSearch")
        static let FooyoUpdateNavigationPoint = Notification.Name("FooyoUpdateNavigationPoint")
        static let FooyoSavedItinerary = Notification.Name("FooyoSavedItinerary")
        
        static let call = Notification.Name("call")
        static let message = Notification.Name("message")
        static let direction = Notification.Name("direction")
        static let modeSwitch = Notification.Name("mode_switch")
        
    }
    
    enum PathType: String {
        case Sheltered = "sheltered"
        case Fastest = "fastest"
    }
    enum TransportationType: String {
        case Foot = "Walk"
        case Express = "Express"
        case Tram = "Tram"
        case BusA = "Bus A"
        case BusB = "Bus B"
        case Drive = "Drive"
    }
    
    enum RouteType: String {
        case Walking = "walking"
        case PSV = "psv"
    }
    static let transportationTypes: [FooyoConstants.TransportationType] = [.Foot, .BusA, .BusB, .Drive, .Express, .Tram]
    static let transportationColors: [UIColor] = [UIColor.walk, UIColor.busA, UIColor.busB, UIColor.drive, UIColor.express, UIColor.tram]

    static let coverImageRatio: CGFloat = 0.64
    static let generalErrorMessage: String = "Sorry, there is unexpected error.\nPlease try again later"
    static let routeNames = [" Walking ", " Bus1 ", " Bus2 ", " Bus3 ", " Express ", " Tram "]
//    static let routeColor = [UIColor.white, UIColor.busOneColor, UIColor.busTwoColor, UIColor.busThreeColor, UIColor.expressColor, UIColor.tramColor]
    static let tripTimeSource = ["Morning", "Afternoon"]
    static let tripDurationSource = ["Half Day", "One Full Day"]
    
    enum ThemeName: String {
        case Culture = "Culture & Heritage"
        case Family = "Family Fun"
        case Hip = "Hip Hangouts"
        case Nature = "Nature & Wildlife"
        case Thrill = "Thrills & Adventures"
    }
    
    static let themes = [FooyoConstants.ThemeName.Culture, FooyoConstants.ThemeName.Thrill, FooyoConstants.ThemeName.Family, FooyoConstants.ThemeName.Hip, FooyoConstants.ThemeName.Nature]
    static let interest: [FooyoConstants.InterestName] = [FooyoConstants.InterestName.Culture, .Outdoors, .Relaxing, .Romantic, .Historical, .Museums, .Kids, .Shopping, .Food, .Night]

////    static let themesImage = ["https://s-media-cache-ak0.pinimg.com/564x/27/14/20/2714208ca62eacb8e95a258acbf3c4f8.jpg",
//                              "http://xleventsblog.com/wp-content/uploads/2015/07/iStock_000061691486_Medium.jpg",
//                              "https://s-media-cache-ak0.pinimg.com/564x/d2/65/3d/d2653ddad1c0a516a80c149173b66135.jpg",
//                              "https://s-media-cache-ak0.pinimg.com/564x/20/a5/38/20a53819db4b0bc4f884e95e68f501e0.jpg",
//                              "https://s-media-cache-ak0.pinimg.com/564x/af/1c/16/af1c164504a1ba946d2ffe7542fc1316.jpg"]

    static let interestsImage = [#imageLiteral(resourceName: "1_culture"), #imageLiteral(resourceName: "2_outdoors"), #imageLiteral(resourceName: "3_relaxing"), #imageLiteral(resourceName: "4_romantic"), #imageLiteral(resourceName: "5_historical"), #imageLiteral(resourceName: "6_museums"), #imageLiteral(resourceName: "7_kids"), #imageLiteral(resourceName: "8_shopping"), #imageLiteral(resourceName: "9_food"), #imageLiteral(resourceName: "10_nightlife")]
    
    enum ViewMode {
        case Map
        case List
    }
    enum SortType {
        case Category
        case AZ
        case Distance
    }
    
    enum FilterType: String {
        case Attraction = "attraction"
        case Event = "event"
        case FB = "fb"
        case Shop = "shop"
        case Hotel = "hotel"
        case LinearTrail = "linear_trail"
        case NonLinearTrail = "non_linear_trail"
        case RestRoom = "rest_room"
        case PrayerRoom = "prayer_room"
        case TickingCounter = "ticketing_counter"
        case BusStop = "bus_stop"
        case TramStop = "tram_stop"
        case ExpressStop = "express_stop"
        case CableStop = "cable_stop"
    }
    enum ChangePoint {
        case ChangeStart
        case ChangeEnd
    }
    
//    enum SearchSource {
//        case FromMap
//        case FromNavigation
//    }
    enum PageSource {
        case FromHomeMap
        case FromItineraryEditMap
        case FromNavigation
    }
    
    enum AnnotationId: String {
        case StartPoint = "start_point"
        case EndPoint = "end_point"
        case StartItem = "start_item"
        case EndItem = "end_item"
        case UserMarker = "user_marker"
        case ItineraryItem = "itinerary_item"
        case ThemeItem = "theme_item"
    }
    
    enum ItemType: String {
        case Attraction = "attraction"
        case Event = "event"
        case FB = "fb"
        case Shop = "shop"
        case Hotel = "hotel"
        case Trail = "trail"
        case RestRoom = "rest_room"
        case PrayerRoom = "prayer_room"
        case TickingCounter = "ticketing_counter"
        case BusStop = "bus_stop"
        case TramStop = "tram_stop"
        case ExpressStop = "express_stop"
        case CableStop = "cable_stop"
    }
    
    enum AuthType {
        case SignIn
        case SignUp
    }

    enum InterestName: String {
        case Culture = "Culture"
        case Outdoors = "Outdoors"
        case Relaxing = "Relaxing"
        case Romantic = "Romantic"
        case Historical = "Historical sites"
        case Museums = "Museums"
        case Kids = "Kids friendly"
        case Shopping = "Shopping"
        case Food = "Food"
        case Night = "Night life"
    }
    enum DynamicType {
        case Replace
        case Switch
        case Add
        case Remove
    }
    
    enum autoItinerary: Int {
        case Cul_Whole_Any = 162
        case Cul_Whole_150 = 161
        case Cul_Whole_100 = 160
        case Cul_Whole_50 = 159
        case Cul_Mor_Any = 166
        case Cul_Mor_150 = 165
        case Cul_Mor_100 = 164
        case Cul_Mor_50 = 163
        case Cul_Aft_Any = 170
        case Cul_Aft_150 = 169
        case Cul_Aft_100 = 168
        case Cul_Aft_50 = 167
        
        case Thr_Whole_Any = 174
        case Thr_Whole_150 = 173
        case Thr_Whole_100 = 172
        case Thr_Whole_50 = 171
        case Thr_Mor_Any = 178
        case Thr_Mor_150 = 177
        case Thr_Mor_100 = 176
        case Thr_Mor_50 = 175
        case Thr_Aft_Any = 182
        case Thr_Aft_150 = 181
        case Thr_Aft_100 = 180
        case Thr_Aft_50 = 179
        
//        func hasValue(id: Int) -> Bool {
//            if self.all
//        }
    }
    
    enum tripType: String {
        case FullDay = "full_day"
        case HalfDayMorning = "half_day_morning"
        case HalfDayAfternoon = "half_day_afternoon"
    }
}
