//
//  ModeloModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ModeloModel: Model, Selectable {
    
    var nome: String?
    var codigo: String?
    
    var value: String {
        return "\(id!)"
    }
    
    var label: String {
        let nome = self.nome ?? ""
        guard let codigo = self.codigo else {
            return nome
        }
        return "\(nome) (\(codigo))"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        codigo <- map["codigo"]
    }
}
