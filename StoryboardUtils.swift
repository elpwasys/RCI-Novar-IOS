//
//  StoryboardUtils.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 12/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import Foundation

class StoryboardUtils {
    
    static func controller(for segue: UIStoryboardSegue) -> UIViewController {
        if segue.destination is UINavigationController {
            let navigation = segue.destination as! UINavigationController
            guard let controller = navigation.viewControllers.first else {
                fatalError("Root view controller not found for segue!")
            }
            return controller
        } else {
            return segue.destination
        }
    }
}
