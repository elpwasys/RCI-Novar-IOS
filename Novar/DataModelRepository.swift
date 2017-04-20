//
//  DataModelRepository.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 24/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import CoreData

class DataModelRepository {
    
    var managedObjectContext: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.managedObjectContext
    }
}
