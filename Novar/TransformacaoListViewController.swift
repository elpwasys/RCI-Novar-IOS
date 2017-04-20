//
//  TransformacaoListViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 05/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class TransformacaoListViewController: NovarViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isEdit = false
    var response: ProcessoResponse?
    
    private var transformacoes = [TransformacaoModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = isEdit
        addButton.isEnabled = isEdit
        if let processo = self.response?.processo {
            if let transformacoes = processo.transformacoes {
                self.transformacoes = transformacoes
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
        return transformacoes.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEdit
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transformacoes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.response?.processo?.transformacoes = transformacoes
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransformacaoTableViewCell", for: indexPath) as! TransformacaoTableViewCell
        let transformacao = transformacoes[indexPath.row]
        cell.popular(transformacao)
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Segue.Add.Transformacao", "Segue.Edit.Transformacao":
            return isEdit
        default:
            return true
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TransformacaoEditViewController {
            if let selectedCell = sender as? TransformacaoTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let transformacao = transformacoes[indexPath.row]
                controller.transformacao = transformacao
            }
            controller.empresas = self.response?.transformacoes
        }
    }
    
    @IBAction func unwindToTransformacaoList(sender: UIStoryboardSegue) {
        if let controller = sender.source as? TransformacaoEditViewController, let transformacao = controller.transformacao {
            if let indexPath = tableView.indexPathForSelectedRow {
                transformacoes[indexPath.row] = transformacao
                tableView.reloadRows(at: [indexPath], with: .none)
            } else if transformacoes.isEmpty {
                transformacoes.append(transformacao)
                tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: transformacoes.count, section: 0)
                transformacoes.append(transformacao)
                tableView.insertRows(at: [indexPath], with: .bottom)
            }
            self.response?.processo?.transformacoes = transformacoes
        }
    }
}
