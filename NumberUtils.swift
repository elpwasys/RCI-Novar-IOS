//
//  NumberUtils.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 15/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class NumberUtils {
    
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = nil
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
    
    static func format(_ value: Double) -> String? {
        let number = NSNumber.init(value: value)
        return formatter.string(from: number)
    }
    
    static func parse(_ value: String) -> Double? {
        return formatter.number(from: value)?.doubleValue
    }
    
    static func parse(_ value: String?) -> Int? {
        guard let text = value else {
            return nil
        }
        return Int(text)
    }
}
