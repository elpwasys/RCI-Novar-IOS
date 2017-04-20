//
//  LoginService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 07/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class LoginService: Service {
    
    static let loginURL = "\(Config.mobileURL)login/"
    
    static func aceitar() -> Observable<Void> {
        return Observable.create { observer in
            let url = "\(loginURL)aceitar"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            let queue = DispatchQueue(label: "br.com.elp.self.http-response", attributes: [.concurrent])
            request.response(queue: queue, completionHandler: { response in
                do {
                    try DataRequest.validate(default: response)
                    observer.onNext()
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            })
            return disposable
        }
    }
    
    static func autenticar(cpf: String, senha: String) -> Observable<UsuarioModel> {
        return Observable.create { observer in
            let url = "\(loginURL)autenticar"
            let parameters = ["cpf": cpf, "senha": senha]
            let request = Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<UsuarioModel>) in
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
