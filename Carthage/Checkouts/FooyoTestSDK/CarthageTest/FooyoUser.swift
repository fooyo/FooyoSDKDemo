//
//  FooyoUser.swift
//  FooyoSDKExample
//
//  Created by Yangfan Liu on 13/9/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit

class FooyoUser: NSObject, NSCoding {

    static var currentUser = FooyoUser()
    
    var userId: String?
    var searchHistory: [Int]?
    //
//    init(json: JSON) {
//        super.init()
//        id = json["id"].int
//    }
    
    override init() {
        super.init()
    }
    
    class func awakeCurrentUserFromDefaults() -> Bool {
        let ud = UserDefaults.standard
        if let data = ud.object(forKey: "current_user") as? NSData {
            let u : FooyoUser = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! FooyoUser
            u.userId = currentUser.userId
            currentUser = u
            return true
        }
        return false
    }
    
    func saveToDefaults() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        let ud = UserDefaults.standard
        ud.set(data, forKey: "current_user")
        ud.synchronize()
    }
    
    class func destoryCurrentUser() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "current_user")
        ud.synchronize()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.searchHistory, forKey: "searchHistory")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        searchHistory = aDecoder.decodeObject(forKey: "searchHistory") as? [Int]
    }
    
    func updateSearchResult(newId: Int) -> Bool {
        if searchHistory == nil {
            searchHistory = [newId]
            return true
        } else {
            if searchHistory!.contains(newId) {
                return false
            } else {
                searchHistory?.append(newId)
                return true
            }
        }
    }
}
