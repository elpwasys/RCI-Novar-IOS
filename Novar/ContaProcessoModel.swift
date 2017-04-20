//
//  ContaProcessoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ContaProcessoModel: Model, Selectable {
    
    var banco: String?
    var numero: String?
    var agencia: String?
    
    var value: String {
        return "\(id!)"
    }
    
    var label: String {
        return "\(banco ?? "") - \(agencia ?? "")/\(numero ?? "")"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        banco <- map["banco"]
        numero <- map["numero"]
        agencia <- map["agencia"]
    }
}
