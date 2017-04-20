//
//  ContaProcessoService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 15/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire


class ContaProcessoService: NovarService {
    
    static let versaoURL = "\(Config.mobileURL)conta/"
    
    static func listar(concessionariaId: Int) -> Observable<[Option]> {
        return Observable.create { observer in
            let url = "\(versaoURL)\("listar")/\(concessionariaId)"
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
