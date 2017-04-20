//
//  ImagemService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 21/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class ImagemService: NovarService {
    
    static let imagemURL = "\(Config.mobileURL)imagem/"
    
    static func listar(documentoId: Int) -> Observable<[ImagemModel]> {
        return Observable.create { observer in
            let url = "\(imagemURL)listar/\(documentoId)"
            let request = Alamofire.request(url, headers: Device.headers)
            let disposable = Disposables.create {
                request.cancel()
            }
            request.parse(handler: {(response: DataResponse<[ImagemModel]>) in
                if response.result.isSuccess {
                    if let imagens = response.result.value {
                        do {
                            try salvar(imagens: imagens, documentoId: documentoId)
                            let directory = try getPathForImagesCache()
                            let contents = try FileManager.default.contentsOfDirectory(atPath: directory)
                            for content in contents {
                                if let index = content.range(of: ".", options: .literal)?.lowerBound {
                                    let nome = content.substring(to: index)
                                    let contains = imagens.contains { return "\($0.id)" == nome }
                                    if !contains {
                                        let path = try getAbsolutePathForCache(for: content)
                                        try FileManager.default.removeItem(atPath: path)
                                    }
                                }
                            }
                            observer.onNext(imagens)
                            observer.onCompleted()
                        } catch {
                            print(error)
                            observer.onError(error)
                        }
                    }
                } else {
                    observer.onError(response.result.error!)
                }
            })
            return disposable
        }
    }
    
    static func download(id: Int) -> Observable<Data> {
        return Observable.create { observer in
            let request: DataRequest!
            do {
                let path = try ImagemService.getAbsolutePathForCache(for: "\(id).jpg")
                if FileManager.default.fileExists(atPath: path) {
                    let url = URL(fileURLWithPath: path)
                    do {
                        let data = try Data(contentsOf: url)
                        observer.onNext(data)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                } else {
                    let url = "\(imagemURL)download/\(id)"
                    request = Alamofire.request(url, headers: Device.headers)
                    request.responseData(completionHandler: { response in
                        if response.result.isSuccess {
                            let data = response.result.value!
                            if data.count > 0 {
                                do {
                                    let url = URL(fileURLWithPath: path)
                                    try data.write(to: url)
                                    observer.onNext(data)
                                    observer.onCompleted()
                                } catch {
                                    observer.onError(Throuble("Erro ao salvar a imagem no diretorio"))
                                }
                            } else {
                                observer.onNext(data)
                                observer.onCompleted()
                            }
                        } else {
                            observer.onError(response.result.error!)
                        }
                    })
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create {
                
            }
        }
    }
    
    static func excluirSync(imagens: [ImagemModel]) throws {
        for imagem in imagens {
            try excluirSync(imagem: imagem)
        }
    }
    
    static func excluirSync(imagem: ImagemModel) throws {
        if let nome = imagem.nome {
            let path = try getAbsolutePathForImages(for: nome)
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
        }
        if let id = imagem.id {
            let repository = ImagemRepository()
            try repository.deleteBy(id: id)
        }
    }
    
    static func excluir(imagem: ImagemModel) -> Observable<Void> {
        return Observable.create { observer in
            do {
                try excluirSync(imagem: imagem)
                observer.onNext()
                observer.onCompleted()
            } catch {
                observer.onError(Throuble("Erro ao excluir imagem \(error)"))
            }
            let disposable = Disposables.create {
                
            }
            return disposable
        }
    }
    
    static func salvar(image: UIImage, documentoId: Int) -> Observable<ImagemModel> {
        return Observable.create { observer in
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                do {
                    // CRIA O NOME DA IMAGEM
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMdd_HHmmss'.jpg'"
                    let nome = formatter.string(from: date)
                    // SALVA A IMAGEM FISICA
                    let path = try getAbsolutePathForImages(for: nome)
                    let url = URL(fileURLWithPath: path)
                    try data.write(to: url)
                    // SALVA A IMAGEM NO BANCO
                    let model = ImagemModel()
                    model.nome = nome
                    model.extensao = "jpg"
                    model.usuario = usuario
                    model.documento = DocumentoModel(documentoId)
                    let repository = ImagemRepository()
                    try repository.save(model)
                    // NOTIFICA
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            } else {
                observer.onError(Throuble("Erro ao converter imagem em bytes (Data)"))
            }
            let disposable = Disposables.create {
                
            }
            return disposable
        }
    }
    
    static func salvar(imagens: [ImagemModel], documentoId: Int) throws {
        let repository = ImagemRepository()
        // EXCLUI TODAS AS IMAGENS ANTIGAS DO DOCUMENTO
        try repository.deleteBy(documentoId: documentoId)
        // INSERE AS IMAGENS DO DOCUMENTO
        let documento = DocumentoModel(documentoId)
        for imagem in imagens {
            imagem.usuario = usuario
            imagem.documento = documento
            try repository.save(imagem)
        }
    }
    
    static func salvar(nome: String, documentoId: Int) -> Observable<ImagemModel> {
        return Observable.create { observer in
            do {
                let imagem = try salvarSincrono(nome: nome, documentoId: documentoId)
                observer.onNext(imagem)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            let disposable = Disposables.create {
                
            }
            return disposable
        }
    }
    
    static func salvarSincrono(nome: String, documentoId: Int) throws -> ImagemModel {
        let imagem = ImagemModel()
        imagem.nome = nome
        imagem.usuario = usuario
        imagem.extensao = "jpg"
        imagem.documento = DocumentoModel(documentoId)
        let repository = ImagemRepository()
        try repository.save(imagem)
        return imagem
    }
    
    static func digitalizar(documentoId: Int) throws {
        let imagemRepository = ImagemRepository()
        if let imagens = try imagemRepository.listBy(documentoId: documentoId) {
            let documentoRepository = DocumentoRepository()
            try documentoRepository.update(id: documentoId, status: .digitalizando)
            let handleSuccess = {
                do {
                    try documentoRepository.update(id: documentoId, status: .digitalizado)
                    try excluirSync(imagens: imagens)
                } catch {
                    print("Erro ao atualizar o status dos documentos para digitalizado ou excluir imagens!")
                }
            };
            let handleFailure = {
                do {
                    try documentoRepository.update(id: documentoId, status: .erroDigitalizacao)
                } catch {
                    print("Erro ao atualizar o status dos documentos para erro de digitalizacao!")
                }
            };
            // REALIZA O UPLOAD DAS IMAGENS EM BACKGROUND
            Alamofire.upload(
                multipartFormData: { multipart in
                    for imagem in imagens {
                        if let id = imagem.id {
                            if let data = "\(id)".data(using: .utf8) {
                                multipart.append(data, withName: "ids")
                            }
                        }
                        else if let nome = imagem.nome {
                            if let path = try? getAbsolutePathForImages(for: nome), FileManager.default.fileExists(atPath: path) {
                                let url = URL(fileURLWithPath: path)
                                multipart.append(url, withName: "files")
                            }
                        }
                    }
                },
                to: "\(imagemURL)digitalizar/\(documentoId)",
                method: .post,
                headers: Device.headers,
                encodingCompletion: { encondingResult in
                    switch encondingResult {
                    case .success(let request, _, _):
                        request.parse(handler: {(response: DataResponse<DataMobileModel>) in
                            if response.result.isSuccess {
                                let model = response.result.value!
                                if model.success! {
                                    handleSuccess()
                                } else {
                                    handleFailure()
                                }
                            } else {
                                handleFailure()
                            }
                        })
                    case .failure(let encodingError):
                        print(encodingError)
                        handleFailure()
                    }
                }
            )
        }
    }
    
    static func getAbsolutePathForCache(for name: String) throws -> String {
        let directory = try getPathForImagesCache()
        return directory.appending(name)
    }
    
    static func getAbsolutePathForImages(for name: String) throws -> String {
        let directory = try getPathForImages()
        return directory.appending(name)
    }
    
    static func getPathForImages() throws -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let directory = paths.first!.appending("/Imagens/")
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        return directory
    }
    
    static func getPathForImagesCache() throws -> String {
        let directory = try getPathForImages()
        let cache = directory.appending("Cache/")
        try FileManager.default.createDirectory(atPath: cache, withIntermediateDirectories: true, attributes: nil)
        return cache
    }
}
