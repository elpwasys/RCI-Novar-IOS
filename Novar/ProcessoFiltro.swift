//
//  ProcessoFiltro.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 24/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class ProcessoFiltro {
    
    var tipo: Tipo = .consulta
    
    var periodoDe: Date?
    var periodoAte: Date?
    
    var pessoa: Pessoa?
    var status: ProcessoModel.Status?
    var cpfCnpj: String?
    var numeroOrcamento: String?
    
    static var padrao: ProcessoFiltro {
        
        let hoje = Date()
        let filtro = ProcessoFiltro()
        filtro.periodoAte = hoje
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -30
        
        filtro.periodoDe = calendar.date(byAdding: components, to: hoje)
        
        return filtro
    }
    
    enum Pessoa {
        case fisica
        case juridica
    }
    
    enum Tipo: String {
        
        case consulta
        case liberados
        case pendencias
        
        var pesquisaURL: String {
            switch self {
            case .consulta:
                return "\(Config.mobileURL)pesquisa/aplicar"
            case .liberados:
                return "\(Config.mobileURL)liberado/aplicar"
            case .pendencias:
                return "\(Config.mobileURL)pendencia/aplicar"
            }
        }
    }
    
    func dictionary() -> [String: String] {
        var dictionary = [String: String]()
        if let status = status {
            dictionary["status"] = status.rawValue
        }
        if let cpfCnpj = cpfCnpj, !cpfCnpj.isEmpty {
            dictionary["cpfCnpj"] = cpfCnpj
        }
        if let periodoDe = periodoDe {
            dictionary["periodoDe"] = DateUtils.format(periodoDe, pattern: DateUtils.DateType.dateBr.pattern)
        }
        if let periodoAte = periodoAte {
            dictionary["periodoAte"] = DateUtils.format(periodoAte, pattern: DateUtils.DateType.dateBr.pattern)
        }
        if let numeroOrcamento = numeroOrcamento, !numeroOrcamento.isEmpty {
            dictionary["numeroOrcamento"] = numeroOrcamento
        }
        return dictionary
    }
}
