//
//  ImagemRepository.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 25/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import CoreData

class ImagemRepository: DataModelRepository {
    
    func save(_ model: ImagemModel) throws {
        guard let usuarioId = model.usuario?.id else {
            throw Throuble("usuario.id is null")
        }
        guard let documentoId = model.documento?.id else {
            throw Throuble("documento.id is null")
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Imagem", into: managedObjectContext)
        if let id = model.id {
            entity.setValue(id, forKey: "id")
        }
        if let nome = model.nome, !nome.isEmpty {
            entity.setValue(nome, forKey: "nome")
        }
        if let extensao = model.extensao, !extensao.isEmpty {
            entity.setValue(extensao, forKey: "extensao")
        }
        entity.setValue(usuarioId, forKey: "usuarioId")
        entity.setValue(documentoId, forKey: "documentoId")
        do {
            try managedObjectContext.save()
        } catch {
            throw Throuble("Erro ao salvar a imagem: \(error)")
        }
    }
    
    func deleteBy(id: Int) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Imagem")
        request.predicate = NSPredicate(format: "id == \(id)")
        do {
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                for object in objects {
                    managedObjectContext.delete(object)
                }
                try managedObjectContext.save()
            }
        } catch {
            throw Throuble("Erro ao excluir as imagens: \(error)")
        }
    }
    
    func listBy(documentoId: Int) throws -> [ImagemModel]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Imagem")
        request.predicate = NSPredicate(format: "documentoId = %ld", documentoId)
        do {
            var imagens: [ImagemModel]?
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                imagens = [ImagemModel]()
                for object in objects {
                    let imagem = ImagemModel()
                    if let id = object.value(forKey: "id") as? Int, id > 0 {
                        imagem.id = object.value(forKey: "id") as? Int
                    }
                    imagem.nome = object.value(forKey: "nome") as? String
                    imagem.extensao = object.value(forKey: "extensao") as? String
                    if let usuarioId = object.value(forKey: "usuarioId") as? Int {
                        imagem.usuario = UsuarioModel(usuarioId)
                    }
                    imagem.documento = DocumentoModel(documentoId)
                    imagens!.append(imagem)
                }
            }
            return imagens
        } catch {
            throw Throuble("Erro ao excluir as imagens: \(error)")
        }
    }
    
    func deleteBy(documentoId: Int) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Imagem")
        request.predicate = NSPredicate(format: "documentoId = %ld", documentoId)
        do {
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                for object in objects {
                    managedObjectContext.delete(object)
                }
                try managedObjectContext.save()
            }
        } catch {
            throw Throuble("Erro ao excluir as imagens: \(error)")
        }
    }
}
