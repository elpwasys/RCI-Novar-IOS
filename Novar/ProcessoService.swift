//
//  ProcessoService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 08/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class ProcessoService: Service {
    
    static let processoURL = "\(Config.mobileURL)processo/"
    
    static func buscar(concessionariaId: Int, numeroOrcamento: String, dataProposta: Date) -> Observable<ProcessoModel> {
        return Observable.create { observer in
            let url = "\(processoURL)buscar"
            let parameters: Parameters = [
                "dataProposta": DateUtils.format(dataProposta, pattern: DateUtils.DateType.dateBr.pattern),
                "numeroOrcamento": numeroOrcamento,
                "concessionariaId": concessionariaId
            ]
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<ProcessoModel>) in
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
    
    static func pesquisar(page: Int, filtro: ProcessoFiltro) -> Observable<PagingModel<ProcessoModel>> {
        return Observable.create { observer in
            let tipo = filtro.tipo
            let parameters: Parameters = ["page": page, "filtro": filtro.dictionary()]
            let request = Alamofire.request(tipo.pesquisaURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<PagingModel<ProcessoModel>>) in
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
    
    static func carregar(id: Int, edicao: Bool) -> Observable<ProcessoResponse> {
        return Observable.create { observer in
            let url = "\(processoURL)\(edicao ? "editar" : "visualizar")/\(id)"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<ProcessoResponse>) in
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
    
    static func salvar(request processo: ProcessoRequest) -> Observable<DataMobileModel> {
        return Observable.create { observer in
            let url = "\(processoURL)salvar"
            let parameters = processo.dictionary()
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
    
    static func finalizar(id: Int) -> Observable<DataMobileModel> {
        return Observable.create { observer in
            let url = "\(processoURL)finalizar/\(id)"
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
}
