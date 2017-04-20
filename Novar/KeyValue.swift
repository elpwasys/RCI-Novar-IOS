//
//  KeyValue.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 19/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class KeyValue {
    let key: String
    let value: String
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    func dictionary() -> [String: String] {
        return [
            "key": key,
            "value": value
        ]
    }
}
