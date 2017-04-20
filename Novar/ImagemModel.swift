//
//  ImagemModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 21/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagemModel: Model {
    
    var nome: String?
    var extensao: String?
    
    var usuario: UsuarioModel?
    var documento: DocumentoModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        extensao <- map["extensao"]
        usuario <- map["usuario"]
        documento <- map["documento"]
    }
}
