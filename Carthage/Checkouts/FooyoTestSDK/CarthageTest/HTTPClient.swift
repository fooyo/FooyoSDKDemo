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
//import Mapbox
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
        Alamofire.request("\(Constants.EndPoint.baseURL)/places", method: .get, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["places"] != nil {
                        var items = [FooyoItem]()
                        items = data["places"].arrayValue.map{ FooyoItem(json: $0) }
                        FooyoItem.items = items
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
        Alamofire.request("\(Constants.EndPoint.baseURL)/categories", method: .get, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            debugPrint(response)
            let code = (response.response?.statusCode) ?? 500
            if code >= 200 && code <= 299 {
                if let json = response.result.value {
                    let data = JSON(json)
                    if data["categories"] != nil {
                        var categories = [FooyoCategory]()
                        categories = data["categories"].arrayValue.map{ FooyoCategory(json: $0) }
                        FooyoCategory.categories = categories
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
}
