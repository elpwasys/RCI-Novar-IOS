//
//  PendenciaModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class PendenciaModel: Model {
    
    var observacao: String?
    var justificativa: String?
    
    var irregularidade: IrregularidadeModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        observacao <- map["observacao"]
        justificativa <- map["justificativa"]
        irregularidade <- map["irregularidade"]
    }
}
