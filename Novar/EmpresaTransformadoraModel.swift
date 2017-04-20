//
//  EmpresaTransformadoraModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class EmpresaTransformadoraModel: Model, Selectable {
    
    var nome: String?
    var cnpj: String?
    var banco: String?
    var numero: String?
    var agencia: String?
    var codigoTab: String?
    var razaoSocial: String?
    var ativo: Bool?
    
    var value: String {
        return "\(id!)"
    }
    
    var label: String {
        return "\(razaoSocial ?? "")"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        cnpj <- map["cnpj"]
        banco <- map["banco"]
        numero <- map["numero"]
        agencia <- map["agencia"]
        codigoTab <- map["codigoTab"]
        razaoSocial <- map["razaoSocial"]
        ativo <- map["ativo"]
    }
}
