//
//  SeguroListaViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 05/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class SeguroListaViewController: NovarViewController, UITableViewDelegate, UITableViewDataSource {

    var isEdit = false
    var response: ProcessoResponse?
    
    private var segurosDocumentos = [SeguroDocumentoModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = isEdit
        addButton.isEnabled = isEdit
        if let processo = self.response?.processo {
            if let segurosDocumentos = processo.segurosDocumentos {
                self.segurosDocumentos = segurosDocumentos
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segurosDocumentos.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEdit
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            segurosDocumentos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.response?.processo?.segurosDocumentos = segurosDocumentos
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeguroDocumentoTableViewCell", for: indexPath) as! SeguroDocumentoTableViewCell
        let seguroDocumento = segurosDocumentos[indexPath.row]
        cell.popular(seguroDocumento)
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Segue.Add.Seguro", "Segue.Edit.Seguro":
            return isEdit
        default:
            return true
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SeguroEdicaoViewController {
            if let selectedCell = sender as? SeguroDocumentoTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let seguroDocumento = segurosDocumentos[indexPath.row]
                controller.seguroDocumento = seguroDocumento
            }
            controller.seguros = self.response?.seguros
        }
    }
    
    @IBAction func unwindToSeguroList(sender: UIStoryboardSegue) {
        if let controller = sender.source as? SeguroEdicaoViewController, let seguroDocumento = controller.seguroDocumento {
            if let indexPath = tableView.indexPathForSelectedRow {
                segurosDocumentos[indexPath.row] = seguroDocumento
                tableView.reloadRows(at: [indexPath], with: .none)
            } else if segurosDocumentos.isEmpty {
                segurosDocumentos.append(seguroDocumento)
                tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: segurosDocumentos.count, section: 0)
                segurosDocumentos.append(seguroDocumento)
                tableView.insertRows(at: [indexPath], with: .bottom)
            }
            self.response?.processo?.segurosDocumentos = segurosDocumentos
        }
    }
}
