//
//  ProcessoResponse.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 28/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ProcessoResponse: Mappable {
    
    var documentos: Int?
    var pendencias: Int?
    
    var processo: ProcessoModel?
    
    var contas: [Option]?
    var seguros: [Option]?
    var transformacoes: [Option]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        contas <- map["contas"]
        seguros <- map["seguros"]
        processo <- map["processo"]
        documentos <- map["documentos"]
        pendencias <- map["pendencias"]
        transformacoes <- map["transformacoes"]
    }
}
