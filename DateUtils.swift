//
//  DateUtils.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class DateUtils {
    
    static let patterns = [
        DateType.date.pattern,
        DateType.dateBr.pattern,
        DateType.iso8601.pattern,
        DateType.dateTimeBr.pattern,
        DateType.dateHourMinuteBr.pattern
    ]
    
    enum DateType {
        
        case date
        case dateBr
        case iso8601
        case dateTimeBr
        case dateHourMinuteBr
        
        var pattern: String {
            switch self {
            case .date:
                return "yyyy-MM-dd"
            case .dateBr:
                return "dd/MM/yyyy"
            case .iso8601:
                return "yyyy-MM-dd'T'HH:mm:ssz"
            case .dateTimeBr:
                return "dd/MM/yyyy HH:mm:ss"
            case .dateHourMinuteBr:
                return "dd/MM/yyyy HH:mm"
            }
        }
    }
    
    static func parse(_ text: String) -> Date? {
        return parse(text, patterns: patterns)
    }
    
    static func parse(_ text: String, patterns: [String]) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        for pattern in patterns {
            formatter.dateFormat = pattern
            if let date = formatter.date(from: text) {
                return date
            }
        }
        return nil
    }
    
    static func format(_ date: Date, type: DateType) -> String {
        return format(date, pattern: type.pattern)
    }
    
    static func format(_ date: Date, pattern: String? = DateType.iso8601.pattern) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }
}
