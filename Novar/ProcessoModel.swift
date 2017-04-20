//
//  ProcessoModel.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class ProcessoModel: Model {
    
    var status: Status?
    var produto: Produto?
    var tipoVenda: TipoVenda?
    var perfilCliente: PerfilCliente?
    var situacaoVeiculo: SituacaoVeiculo?
    
    var editavel: Bool?
    var finalizavel: Bool?
    var possuiBoleto: Bool?
    var possuiAvalista: Bool?
    
    var dataCriacao: Date?
    var dataProposta: Date?
    var vencimentoBoleto: Date?
    
    var chassi: String?
    var cpfAvalista: String?
    var nomeAvalista: String?
    var numeroBoleto: String?
    var numeroProposta: String?
    var nomeFinanciado: String?
    var codigoOperador: String?
    var codigoVendedor: String?
    var ufEmplacamento: String?
    var numeroOrcamento: String?
    var cpfCnpjFinanciado: String?
    var justificativaAcessorios: String?
    
    var anoVersao: Int?
    var codigoTabela: Int?
    var anoFabricacao: Int?
    var retornoVendedor: Int?
    var retornoConcessionaria: Int?
    
    var valorBoleto: Double?
    var valorAprovacao: Double?
    var valorFinanciado: Double?
    var valorAcessorios: Double?
    
    var marca: MarcaModel?
    var modelo: ModeloModel?
    var versao: VersaoModel?
    var conta: ContaProcessoModel?
    var tipoProcesso: TipoProcessoModel?
    var concessionaria: ConcessionariaModel?
    
    var deletados: [DocumentoModel]?
    var documentos: [DocumentoModel]?
    var transformacoes: [TransformacaoModel]?
    var segurosDocumentos: [SeguroDocumentoModel]?
    
    enum Status: String, Selectable {
        case criado = "CRIADO"
        case digitalizado = "DIGITALIZADO"
        case pendente = "PENDENTE"
        case conferido = "CONFERIDO"
        case retornado = "RETORNADO"
        case digitado = "DIGITADO"
        case liberado = "LIBERADO"
        case pendenteFisico = "PENDENTE_FISICO"
        case concluido = "CONCLUIDO"
        case contratoCancelado = "CONTRATO_CANCELADO"
        case expirado = "EXPIRADO"
        case cancelado = "CANCELADO"
        var key: String {
            return "Processo.Status.\(self)"
        }
        var image: UIImage? {
            return UIImage(named: key)
        }
        var value: String {
            return rawValue
        }
        var label: String {
            return TextUtils.localizedString(forKey: key)
        }
        static let values = [
            Status.criado,
            Status.digitalizado,
            Status.pendente,
            Status.conferido,
            Status.retornado,
            Status.digitado,
            Status.liberado,
            Status.pendenteFisico,
            Status.concluido,
            Status.contratoCancelado,
            Status.expirado,
            Status.cancelado
        ]
    }
    
    enum Produto: String {
        case cdc = "CDC"
        case lsg = "LSG"
        case cdcFlex = "CDC_FLEX"
        var key: String {
            return "Processo.Produto.\(self)"
        }
        var label: String {
            return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        }
        static var labels: [String] {
            var labels = [String]()
            for value in values {
                labels.append(value.label)
            }
            return labels
        }
        static let values = [
            Produto.cdc,
            Produto.lsg,
            Produto.cdcFlex
        ]
    }
    
    enum TipoVenda: String {
        case direta = "DIRETA"
        case eCommerce = "E_COMMERCE"
        case outro = "OUTRO"
        var key: String {
            return "Processo.TipoVenda.\(self)"
        }
        var label: String {
            return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        }
        static var labels: [String] {
            var labels = [String]()
            for value in values {
                labels.append(value.label)
            }
            return labels
        }
        static let values = [
            TipoVenda.direta,
            TipoVenda.eCommerce,
            TipoVenda.outro
        ]
    }
    
    enum PerfilCliente: String {
        case pne = "PNE"
        case taxista = "TAXISTA"
        case outro = "OUTRO"
        var key: String {
            return "Processo.PerfilCliente.\(self)"
        }
        var label: String {
            return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        }
        static var labels: [String] {
            var labels = [String]()
            for value in values {
                labels.append(value.label)
            }
            return labels
        }
        static let values = [
            PerfilCliente.pne,
            PerfilCliente.taxista,
            PerfilCliente.outro
        ]
    }
    
    enum SituacaoVeiculo: String {
        case zeroKm = "ZERO_KM"
        case usado = "USADO"
        var key: String {
            return "Processo.SituacaoVeiculo.\(self)"
        }
        var label: String {
            return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        }
        static var labels: [String] {
            var labels = [String]()
            for value in values {
                labels.append(value.label)
            }
            return labels
        }
        static let values = [
            SituacaoVeiculo.zeroKm,
            SituacaoVeiculo.usado
        ]
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map: map)
        
        status <- map["status"]
        produto <- map["produto"]
        tipoVenda <- map["tipoVenda"]
        perfilCliente <- map["perfilCliente"]
        situacaoVeiculo <- map["situacaoVeiculo"]
        
        editavel <- map["editavel"]
        finalizavel <- map["finalizavel"]
        possuiBoleto <- map["possuiBoleto"]
        possuiAvalista <- map["possuiAvalista"]
        
        let dateTransform = DateTransformType()
        
        dataCriacao <- (map["dataCriacao"], dateTransform)
        dataProposta <- (map["dataProposta"], dateTransform)
        vencimentoBoleto <- (map["vencimentoBoleto"], dateTransform)
        
        chassi <- map["chassi"]
        cpfAvalista <- map["cpfAvalista"]
        nomeAvalista <- map["nomeAvalista"]
        numeroBoleto <- map["numeroBoleto"]
        numeroProposta <- map["numeroProposta"]
        nomeFinanciado <- map["nomeFinanciado"]
        codigoOperador <- map["codigoOperador"]
        codigoVendedor <- map["codigoVendedor"]
        ufEmplacamento <- map["ufEmplacamento"]
        numeroOrcamento <- map["numeroOrcamento"]
        cpfCnpjFinanciado <- map["cpfCnpjFinanciado"]
        justificativaAcessorios <- map["justificativaAcessorios"]
        
        anoVersao <- map["anoVersao"]
        codigoTabela <- map["codigoTabela"]
        anoFabricacao <- map["anoFabricacao"]
        retornoVendedor <- map["retornoVendedor"]
        retornoConcessionaria <- map["retornoConcessionaria"]
        
        valorBoleto <- map["valorBoleto"]
        valorAprovacao <- map["valorAprovacao"]
        valorFinanciado <- map["valorFinanciado"]
        valorAcessorios <- map["valorAcessorios"]
        
        marca <- map["marca"]
        modelo <- map["modelo"]
        versao <- map["versao"]
        conta <- map["conta"]
        tipoProcesso <- map["tipoProcesso"]
        concessionaria <- map["concessionaria"]
        
        deletados <- map["deletados"]
        documentos <- map["documentos"]
        transformacoes <- map["transformacoes"]
        segurosDocumentos <- map["segurosDocumentos"]
    }
}
