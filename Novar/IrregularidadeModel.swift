//
//  IrregularidadeModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class IrregularidadeModel: Model {
    
    var descricao: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        descricao <- map["descricao"]
    }
}
