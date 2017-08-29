//
//  Pagination.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 24/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
import SwiftyJSON

class FooyoPagination: BaseModel {
    var currentPage: Int?
    var nextPage: Int?
    var prevPage: Int?
    var totalPages: Int?
    var totalCount: Int?
    var loaded: Bool = false
    var error: String?
    var firstTimeLoaded: Bool = false
    
    var canContinue: Bool {
        get {
            return loaded && (nextPage != nil)
        }
    }
    
    init(json: JSON) {
        super.init()
        currentPage = json["current_page"].int
        nextPage = json["next_page"].int
        prevPage = json["prev_page"].int
        totalPages = json["total_pages"].int
        totalCount = json["total_count"].int
    }
    
    override init() {
        super.init()
    }
    
    func resetData() {
        currentPage = 1
    }
    func updatePage() {
        currentPage = nextPage
    }
    func resetStatus() {
        loaded = false
    }
    func reset() {
        resetData()
        resetStatus()
        firstTimeLoaded = false
    }
    
    func assignedWith(_ object: FooyoPagination?) {
        if let page = object {
            self.currentPage = page.currentPage
            self.nextPage = page.nextPage
            self.prevPage = page.prevPage
            self.totalPages = page.totalPages
            self.totalCount = page.totalCount
        }
    }
}
