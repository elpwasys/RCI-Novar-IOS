//
//  ProcessoLegandaViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 09/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class ProcessoLegandaViewController: UITableViewController {

    let rows = ProcessoModel.Status.values
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessoLegendaTableViewCell", for: indexPath) as! ProcessoLegendaTableViewCell
        let status = rows[indexPath.row]
        cell.popular(status)
        return cell
    }
}
