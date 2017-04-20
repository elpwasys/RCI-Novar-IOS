//
//  SeguroDocumentoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class SeguroDocumentoModel: Model {
    
    var seguro: SeguroModel?
    var documento: DocumentoModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        seguro <- map["seguro"]
        documento <- map["documento"]
    }
}
