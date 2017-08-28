//
//  DateTimeTool.swift
//  SmartSentosa
//
//  Created by Yangfan Liu on 23/2/17.
//  Copyright © 2017 Yangfan Liu. All rights reserved.
//

import UIKit
//import DateToolsSwift

class DateTimeTool: NSObject {
    static var formatOne = "HH:mm"
    static var formatTwo = "MMM dd, YYYY"
    static var formatThree = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    static var formatFour = "HH:mm a"
    static var formatFive = "yyyy-MM-dd"
    static var formatSix = "HH:mm a, yyyy-MM-dd"
    
    // MARK: - Date to String
    class func fromDateToFormatOne(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatOne
        return format.string(from: date)
    }
    class func fromDateToFormatTwo(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatTwo
        return format.string(from: date)
    }
    class func fromDateToFormatThree(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatThree
        return format.string(from: date)
    }
    
    class func fromDateToFormatFour(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatFour
        return format.string(from: date)
    }
    class func fromDateToFormatFive(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatFive
        return format.string(from: date)
    }
    class func fromDateToFormatSix(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = formatSix
        return format.string(from: date)
    }
    
    // MARK: - String to Date
    class func fromFormatOneToDate(_ date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = formatOne
        return format.date(from: date)!
    }
    class func fromFormatThreeToDate(_ date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = formatThree
        return format.date(from: date)!
    }
    
    class func fromFormatFiveToDate(_ date: String) -> Date {
        let format = DateFormatter()
        format.dateFormat = formatFive
        return format.date(from: date)!
    }
    // MARK: - String to String
    class func fromFormatThreeToFormatSix(date: String) -> String {
        let date = fromFormatThreeToDate(date)
        let str = fromDateToFormatSix(date: date)
        return str
    }
    class func fromFormatThreeToFormatTwo(date: String) -> String {
        let date = fromFormatThreeToDate(date)
        let str = fromDateToFormatTwo(date: date)
        return str
    }
    class func fromFormatThreeToFormatOne(date: String) -> String {
        let date = fromFormatThreeToDate(date)
        let str = fromDateToFormatOne(date: date)
        return str
    }
    class func fromFormatThreeToFormatFour(date: String) -> String {
        let date = fromFormatThreeToDate(date)
        let str = fromDateToFormatFour(date: date)
        return str
    }
    class func fromFormatThreeToFormatFive(date: String) -> String {
        let date = fromFormatThreeToDate(date)
        let str = fromDateToFormatFive(date: date)
        return str
    }
    
    class func addMins(startDate: Date, mins: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: mins, to: startDate)
        return date!
    }
    
}
