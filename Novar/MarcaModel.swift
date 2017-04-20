//
//  MarcaModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class MarcaModel: Model, Selectable {
    
    var nome: String?
    
    var value: String {
        get {
            return "\(id!)"
        }
        set {
            
        }
    }
    
    var label: String {
        return nome ?? ""
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
    }
}
