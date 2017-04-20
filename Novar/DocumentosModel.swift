//
//  DocumentosModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentosModel: Model {
    
    var data: Date?
    var finalizavel: Bool?
    var deletados: [DocumentoModel]?
    var solicitados: [DocumentoModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        data <- (map["data"], dateTransform)
        finalizavel <- map["finalizavel"]
        deletados <- map["deletados"]
        solicitados <- map["solicitados"]
    }
}
