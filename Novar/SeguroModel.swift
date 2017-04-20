//
//  SeguroModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class SeguroModel: Model, Selectable {
    
    var ativo: Bool?
    var descricao: String?
    
    var value: String {
        return "\(id!)"
    }
    
    var label: String {
        return "\(descricao ?? "")"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        ativo <- map["ativo"]
        descricao <- map["descricao"]
    }
}
