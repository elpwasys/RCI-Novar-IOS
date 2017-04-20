//
//  DocumentoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentoModel: Model {
    
    var data: Date?
    var nome: String?
    var status: Status?
    var extensao: String?
    var valorSeguro: Double?
    var obrigatorio: Bool?
    var digitalizavel: Bool?
    
    var altura: Int?
    var largura: Int?
    
    var processo: ProcessoModel?
    var pendencia: PendenciaModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        data <- (map["data"], dateTransform)
        nome <- map["nome"]
        status <- map["status"]
        extensao <- map["extensao"]
        valorSeguro <- map["valorSeguro"]
        obrigatorio <- map["obrigatorio"]
        digitalizavel <- map["digitalizavel"]
        altura <- map["altura"]
        largura <- map["largura"]
        processo <- map["processo"]
        pendencia <- map["pendencia"]
    }
    
    enum Status: String {
        case criado = "CRIADO"
        case digitalizado = "DIGITALIZADO"
        case pendente = "PENDENTE"
        case aprovado = "APROVADO"
        case aguardandoFisico = "AGUARDANDO_FISICO"
        case enviadoFisico = "ENVIADO_FISICO"
        case pendenteFisico = "PENDENTE_FISICO"
        case concluido = "CONCLUIDO"
        case deletado = "DELETADO"
        case digitalizando = "DIGITALIZANDO"
        case erroDigitalizacao = "ERRO_DIGITALIZACAO"
        var key: String {
            return "Documento.Status.\(self)"
        }
        var label: String {
            return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        }
        var image: UIImage? {
            return UIImage(named: key)
        }
        static var labels: [String] {
            var labels = [String]()
            for value in values {
                labels.append(value.label)
            }
            return labels
        }
        static let values = [
            Status.criado,
            Status.digitalizado,
            Status.pendente,
            Status.aprovado,
            Status.aguardandoFisico,
            Status.enviadoFisico,
            Status.pendenteFisico,
            Status.concluido,
            Status.deletado,
            Status.digitalizando,
            Status.erroDigitalizacao
        ]
    }
}
