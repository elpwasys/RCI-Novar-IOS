//
//  DocumentoService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 01/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class DocumentoService: NovarService {
 
    static let documentoURL = "\(Config.mobileURL)documento/"
    
    static func buscar(processoId: Int) -> Observable<DocumentosModel> {
        return Observable.create { observer in
            let url = "\(documentoURL)buscar/\(processoId)"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<DocumentosModel>) in
                if response.result.isSuccess {
                    if let model = response.result.value, let solicitados = model.solicitados {
                        var cache = [Int: DocumentoModel]()
                        let repository = DocumentoRepository()
                        do {
                            // BUSCA TODOS OS DOCUMENTOS COM STATUS DE DIGITALIZANDO E ERRO_DIGITALIZACAO
                            let sincronizandos = try repository.listBy(processoId: processoId, status: DocumentoModel.Status.digitalizando, DocumentoModel.Status.erroDigitalizacao)
                            if let documentos = sincronizandos {
                                for documento in documentos {
                                    cache[documento.id!] = documento
                                }
                            }
                            // EXCLUI OS DOCUMENTOS COM STATUS DIFERENTE DE DIGITALIZANDO E ERRO_DIGITALIZACAO
                            try repository.delete(processoId: processoId, status: DocumentoModel.Status.digitalizando, DocumentoModel.Status.erroDigitalizacao)
                            // DOCUMENTOS PARA SALVAR
                            var documentos = [DocumentoModel]()
                            // ADICIONA OS DOCUMENTOS SOLICITADOS PARA SALVAR (COM STATUS DIFERENTE DE DIGITALIZANDO E ERRO_DIGITALIZACAO)
                            for solicitado in solicitados {
                                if cache.index(forKey: solicitado.id!) == nil {
                                    documentos.append(solicitado)
                                }
                            }
                            // ADICIONA OS DOCUMENTOS DELETADOS PARA SALVAR
                            if let deletados = model.deletados {
                                for deletado in deletados {
                                    if cache.index(forKey: deletado.id!) == nil {
                                        documentos.append(deletado)
                                    }
                                }
                            }
                            // SALVA OS DOCUMENTOS
                            let data = model.data
                            let processo = ProcessoModel(processoId)
                            for documento in documentos {
                                documento.data = data
                                documento.processo = processo
                                try repository.save(documento)
                            }
                            for solicitado in solicitados {
                                if cache.index(forKey: solicitado.id!) == nil {
                                    cache[solicitado.id!] = solicitado
                                }
                            }
                            // ATUALIZA O MODELO
                            model.solicitados = cache.map { $0.1 }
                            // NOTIFICA E COMPLETA
                            observer.onNext(model)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    } else {
                        observer.onError(Throuble("Nenhum documento encontrado."))
                    }
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return disposable
        }
    }
    
    static func justificar(documentoId: Int, justificativa: String) -> Observable<DataMobileModel> {
        return Observable.create { observer in
            let url = "\(documentoURL)justificar"
            let parameters: [String : Any] = [
                "documentoId": documentoId,
                "justificativa": justificativa
            ];
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<DataMobileModel>) in
                if response.result.isSuccess {
                    observer.onNext(response.result.value!)
                    observer.onCompleted()
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return disposable
        }
    }
    
    static func excluir(id: Int) -> Observable<DataMobileModel> {
        return Observable.create { observer in
            let url = "\(documentoURL)excluir/\(id)"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<DataMobileModel>) in
                if response.result.isSuccess {
                    observer.onNext(response.result.value!)
                    observer.onCompleted()
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return disposable
        }
    }
    
    static func adicionar(id: Int, ids: [Int]) -> Observable<DataMobileModel> {
        return Observable.create { observer in
            let url = "\(documentoURL)adicionar"
            let parameters: [String : Any] = [
                "processoId": id,
                "documentos": ids
            ];
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<DataMobileModel>) in
                if response.result.isSuccess {
                    observer.onNext(response.result.value!)
                    observer.onCompleted()
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return disposable
        }
    }
}
