//
//  SobreViewController.swift
//  NavigationDrawer
//
//  Created by Everton Luiz Pascke on 18/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class SobreViewController: DrawerViewController {
    
    @IBOutlet weak var versaoLabel: UILabel!
    @IBOutlet weak var drawerButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        drawerButton.target = revealViewController()
        drawerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        let dictionary = Bundle.main.infoDictionary
        if let version = dictionary?["CFBundleShortVersionString"] as? String {
            versaoLabel.text = version
        } else if let version = dictionary?["CFBundleVersion"] as? String {
            versaoLabel.text = version
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
