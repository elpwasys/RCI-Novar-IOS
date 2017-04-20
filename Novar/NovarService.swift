//
//  NovarService.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 07/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class NovarService: Service {
    
    static var usuario: UsuarioModel? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return delegate.usuario
    }
}
