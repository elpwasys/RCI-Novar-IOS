//
//  DocumentoRepository.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 24/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import CoreData

class DocumentoRepository: DataModelRepository {
    
    func save(_ model: DocumentoModel) throws {
        guard let id = model.id else {
            throw Throuble("id is null")
        }
        guard let data = model.data else {
            throw Throuble("data is null")
        }
        guard let status = model.status?.rawValue else {
            throw Throuble("status is null")
        }
        guard let processoId = model.processo?.id else {
            throw Throuble("processo.id is null")
        }
        guard let nome = model.nome, !nome.isEmpty else {
            throw Throuble("nome is null")
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Documento", into: managedObjectContext)
        entity.setValue(id, forKey: "id")
        entity.setValue(data, forKey: "data")
        entity.setValue(nome, forKey: "nome")
        entity.setValue(status, forKey: "status")
        entity.setValue(processoId, forKey: "processoId")
        do {
            try managedObjectContext.save()
        } catch {
            throw Throuble("Erro ao salvar o documento: \(error)")
        }
    }
    
    func update(id: Int, status: DocumentoModel.Status) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Documento")
        request.predicate = NSPredicate(format: "id = %ld", id)
        do {
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                for object in objects {
                    object.setValue(status.rawValue, forKey: "status")
                }
                try managedObjectContext.save()
            }
        } catch {
            throw Throuble("Erro ao atualizar o documento: \(error)")
        }
    }
    
    func listBy(processoId: Int, status: DocumentoModel.Status...) throws -> [DocumentoModel]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Documento")
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "processoId = %ld", processoId))
        var rawValues = [String]()
        for current in status {
            rawValues.append(current.rawValue)
        }
        predicates.append(NSPredicate(format: "status in %@", rawValues))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                var models = [DocumentoModel]()
                for object in objects {
                    let model = DocumentoModel()
                    model.id = object.value(forKey: "id") as? Int
                    model.nome = object.value(forKey: "nome") as? String
                    model.data = object.value(forKey: "data") as? Date
                    model.status = DocumentoModel.Status(rawValue: object.value(forKey: "status") as! String)
                    model.processo = ProcessoModel(processoId)
                    models.append(model)
                }
                return models
            }
        } catch {
            throw Throuble("Erro ao listar os documentos: \(error)")
        }
        return nil
    }
    
    func delete(processoId: Int, status: DocumentoModel.Status...) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Documento")
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "processoId = %ld", processoId))
        var rawValues = [String]()
        for current in status {
            rawValues.append(current.rawValue)
        }
        predicates.append(NSPredicate(format: "not (status in %@)", rawValues))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            let objects = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if objects.count > 0 {
                for object in objects {
                    managedObjectContext.delete(object)
                }
                try managedObjectContext.save()
            }
        } catch {
            throw Throuble("Erro ao excluir os documentos: \(error)")
        }
    }
}
