//
//  ProcessoRequest.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 19/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class ProcessoRequest {
    
    var contaId: Int?
    var marcaId: Int?
    var modeloId: Int?
    var versaoId: Int?
    var processoId: Int?
    var concessionariaId: Int?
    
    var numeroBoleto: Int?
    
    var dataProposta: Date?
    var vencimentoBoleto: Date?
    
    var cpfAvalista: String?
    var nomeAvalista: String?
    var codigoOperador: String?
    var codigoVendedor: String?
    var ufEmplacamento: String?
    var numeroProposta: String?
    var numeroOrcamento: String?
    var cpfCnpjFinanciado: String?
    var justificativaAcessorios: String?
    
    var valorBoleto: Double?
    var valorAcessorios: Double?
    
    var retornoVendedor: Int?
    var retornoConcessionaria: Int?
    
    var tipoVenda: ProcessoModel.TipoVenda?
    var perfilCliente: ProcessoModel.PerfilCliente?
    
    var seguros: [KeyValue]?
    var transformacoes: [KeyValue]?
    
    init(_ id: Int?) {
        processoId = id
    }
    
    func dictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if let value = contaId {
            dictionary["contaId"] = "\(value)"
        }
        if let value = marcaId {
            dictionary["marcaId"] = "\(value)"
        }
        if let value = modeloId {
            dictionary["modeloId"] = "\(value)"
        }
        if let value = versaoId {
            dictionary["versaoId"] = "\(value)"
        }
        if let value = processoId {
            dictionary["processoId"] = "\(value)"
        }
        if let value = concessionariaId {
            dictionary["concessionariaId"] = "\(value)"
        }
        if let value = numeroBoleto {
            dictionary["numeroBoleto"] = "\(value)"
        }
        if let value = dataProposta {
            dictionary["dataProposta"] = DateUtils.format(value, type: .dateBr)
        }
        if let value = vencimentoBoleto {
            dictionary["vencimentoBoleto"] = DateUtils.format(value, type: .dateBr)
        }
        if TextUtils.isNotBlank(cpfAvalista) {
            dictionary["cpfAvalista"] = cpfAvalista
        }
        if TextUtils.isNotBlank(nomeAvalista) {
            dictionary["nomeAvalista"] = nomeAvalista
        }
        if TextUtils.isNotBlank(codigoOperador) {
            dictionary["codigoOperador"] = codigoOperador
        }
        if TextUtils.isNotBlank(codigoVendedor) {
            dictionary["codigoVendedor"] = codigoVendedor
        }
        if TextUtils.isNotBlank(ufEmplacamento) {
            dictionary["ufEmplacamento"] = ufEmplacamento
        }
        if TextUtils.isNotBlank(numeroProposta) {
            dictionary["numeroProposta"] = numeroProposta
        }
        if TextUtils.isNotBlank(numeroOrcamento) {
            dictionary["numeroOrcamento"] = numeroOrcamento
        }
        if TextUtils.isNotBlank(cpfCnpjFinanciado) {
            dictionary["cpfCnpjFinanciado"] = cpfCnpjFinanciado
        }
        if TextUtils.isNotBlank(justificativaAcessorios) {
            dictionary["justificativaAcessorios"] = justificativaAcessorios
        }
        if let value = valorBoleto {
            dictionary["valorBoleto"] = NumberUtils.format(value)
        }
        if let value = valorAcessorios {
            dictionary["valorAcessorios"] = NumberUtils.format(value)
        }
        if let value = retornoVendedor {
            dictionary["retornoVendedor"] = "\(value)"
        }
        if let value = retornoConcessionaria {
            dictionary["retornoConcessionaria"] = "\(value)"
        }
        if let value = tipoVenda {
            dictionary["tipoVenda"] = value.rawValue
        }
        if let value = perfilCliente {
            dictionary["perfilCliente"] = value.rawValue
        }
        if let seguros = self.seguros, !seguros.isEmpty {
            var array = [[String: String]]()
            for seguro in seguros {
                array.append(seguro.dictionary())
            }
            dictionary["seguros"] = array
        }
        if let transformacoes = self.transformacoes, !transformacoes.isEmpty {
            var array = [[String: String]]()
            for transformacao in transformacoes {
                array.append(transformacao.dictionary())
            }
            dictionary["transformacoes"] = array
        }
        return dictionary
    }
}
