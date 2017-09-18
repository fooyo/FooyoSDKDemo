//
//  NSobject-SS.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 22/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import Mapbox
import Alamofire
import AlamofireImage
import SVProgressHUD

extension NSObject {
    
    public func FooyoSDKSetUserId(userId: String) {
        FooyoUser.currentUser.userId = userId
    }
    
    func parseOptionalString(input: String?, defaultValue: String = "") -> String {
        if let input = input {
            return input
        }
        return defaultValue
    }
        
    func findMatchingStr(input: String, regex: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return nil }
        
        let nsString = input as NSString
        let results  = regex.matches(in: input, options: [], range: NSMakeRange(0, nsString.length))
        let strs = results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
        return strs.first?[1]
    }
    func fetchDataAtBackground() {
        debugPrint("fetchDataAtBackground")
        getItineraries()
    }
    func getItineraries() {
    }
    
    func applyGeneralVCSettings(vc: UIViewController) {
        
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/*"])
        Alamofire.DataRequest.addAcceptableImageContentTypes(["image/jpg"])
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
    MGLAccountManager.setAccessToken("pk.eyJ1IjoicHVzaGlhbiIsImEiOiJjaXdyaXptNDAweG1rMm90YmRnZHl0dDFpIn0.9kBN2eXNRe3uZ9VMoMhfhg")
        let backButton = UIBarButtonItem()
        backButton.title = ""
        vc.navigationItem.backBarButtonItem = backButton
        vc.view.backgroundColor = .white
    }
    
    
    func PostAlertNotification(title: String, message: String) {
        let info = [
            "title": title,
            "message": message
        ]
        let notification = Notification(name: FooyoConstants.notifications.FooyoDisplayAlert, object: info, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func PostUpdateHistoryNotification() {
        let notification = Notification(name: FooyoConstants.notifications.FooyoUpdateHistory, object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func PostSearchNotification(item: FooyoItem) {
        let notification = Notification(name: FooyoConstants.notifications.FooyoSearch, object: item, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    func PostUpdateNavigationPointNotification(item: FooyoItem) {
        let notification = Notification(name: FooyoConstants.notifications.FooyoUpdateNavigationPoint, object: item, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    func PostItinerarySavedNotification(plan: FooyoItinerary) {
        let notification = Notification(name: FooyoConstants.notifications.FooyoSavedItinerary, object: plan, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
//    func PostItinerarySavedNotification() {
//        let notification = Notification(name: FooyoConstants.notifications.FooyoSavedItinerary, object: nil, userInfo: nil)
//        NotificationCenter.default.post(notification)
//    }
}
