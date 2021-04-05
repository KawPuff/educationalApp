//
//  DateExtension.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 17.03.2021.
//

import Foundation

extension Date {
    
    var firstWeekDay:Date?{
        get{
            let calendar = Calendar(identifier: .iso8601)
            let firstWeekDay = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear,.weekOfYear], from: self))
            return firstWeekDay
        }
    }
    var lastWeekDay:Date?{
        get{
            let calendar = Calendar(identifier: .iso8601)
            let firstWeekDay = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear,.weekOfYear], from: self))
            return calendar.date(byAdding: .day, value: 6, to: firstWeekDay!)
        }
    }
    
    func toStringWithFormat(format:String)->String{
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        dateFormatter.locale = Locale(identifier: "RU_ru")
        
        return dateFormatter.string(from: self)
        
    }
    
    func toStringWithFormatAndOffset(format:String,offsetComponent: Calendar.Component,offset:Int) -> String {
        let calendar = Calendar(identifier: .gregorian)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        dateFormatter.locale = Locale(identifier: "RU_ru")
        
        let dateWithOffset = calendar.date(byAdding: offsetComponent, value: offset, to: self)!
        return dateFormatter.string(from: dateWithOffset)
    }
}
