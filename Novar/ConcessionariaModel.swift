//
//  ConcessionariaModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 07/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ConcessionariaModel: Model, Selectable {
    
    var nome: String?
    var cnpj: String?
    var grupo: String?
    var codigoTab: String?
    var razaoSocial: String?
    
    var regiao: RegiaoModel?
    
    var value: String {
        return "\(id!)"
    }
    
    var label: String {
        let razaoSocial = self.razaoSocial ?? ""
        guard let codigoTab = self.codigoTab else {
            return razaoSocial
        }
        return "\(codigoTab) - \(razaoSocial)"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        cnpj <- map["cnpj"]
        grupo <- map["grupo"]
        codigoTab <- map["codigoTab"]
        razaoSocial <- map["razaoSocial"]
        regiao <- map["regiao"]
    }
}
