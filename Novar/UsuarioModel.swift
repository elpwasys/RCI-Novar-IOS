//
//  UsuarioModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 07/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class UsuarioModel: Model {
    
    var cpf: String?
    var nome: String?
    var email: String?
    var termoAceite: Bool?
    var concessionarias: [ConcessionariaModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cpf <- map["cpf"]
        nome <- map["nome"]
        email <- map["email"]
        termoAceite <- map["termoAceite"]
        concessionarias <- map["concessionarias"]
    }
}
