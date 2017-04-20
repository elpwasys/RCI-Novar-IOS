//
//  MessageViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 03/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fecharPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
