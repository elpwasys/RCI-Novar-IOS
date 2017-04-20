//
//  VersaoService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 02/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class VersaoService: NovarService {
    
    static let versaoURL = "\(Config.mobileURL)versao/"
    
    static func listar(processoId: Int, marcaId: Int, modeloId: Int) -> Observable<[Option]> {
        return Observable.create { observer in
            let url = "\(versaoURL)\("listar")/\(processoId)/\(marcaId)/\(modeloId)"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<[Option]>) in
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
