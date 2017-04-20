//
//  RegiaoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 07/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class RegiaoModel: Model {
    
    var nome: String?
    var codigo: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        codigo <- map["codigo"]
    }
}
