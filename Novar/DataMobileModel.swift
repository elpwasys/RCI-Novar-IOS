//
//  DataMobileModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import ObjectMapper

class DataMobileModel: Model {
    
    var success: Bool?
    var message: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        success <- map["success"]
        message <- map["message"]
    }
}
