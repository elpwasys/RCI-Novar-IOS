//
//  TextUtils.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class TextUtils {
    
    static func isNotBlank(_ value: String?) -> Bool {
        return !isBlank(value)
    }
    
    static func isBlank(_ value: String?) -> Bool {
        guard let text = value else {
            return true
        }
        return text.isEmpty
    }
    
    static func text(_ value: Any?, for label: UILabel) {
        label.text = text(value)
    }
    
    static func text(_ value: Any?, for field: UITextField) {
        field.text = text(value)
    }
    
    static func text(_ value: Any?) -> String? {
        var text: String?
        if let value = value as? Date {
            text = DateUtils.format(value, pattern: DateUtils.DateType.dateBr.pattern)
        } else if let value = value as? Int {
            text = "\(value)"
        } else if let value = value as? Double {
            text = NumberUtils.format(value)
        } else if let value = value {
            text = "\(value)"
        }
        return text
    }
    
    static func localizedString(forKey: String) -> String {
        return Bundle.main.localizedString(forKey: forKey, value: nil, table: nil)
    }
}
