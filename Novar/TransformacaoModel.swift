//
//  TransformacaoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class TransformacaoModel: Model {
    
    var valor: Double?
    var empresaTransformadora: EmpresaTransformadoraModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        valor <- map["valor"]
        empresaTransformadora <- map["empresaTransformadora"]
    }
}
