//
//  OpcionalViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class OpcionalViewController: NovarViewController, UITableViewDelegate, UITableViewDataSource, OptionalTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    var id: Int?
    var ids = [Int]()
    var deletados = [DocumentoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deletados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpcionalTableViewCell", for: indexPath) as! OpcionalTableViewCell
        let documento = deletados[indexPath.row]
        cell.popular(documento)
        cell.delegate = self
        return cell
    }
    
    func onSwitchChange(isOn: Bool, id: Int) {
        let index = ids.index(of: id)
        if isOn {
            if index == nil {
                ids.append(id)
            }
        } else {
            if index != nil {
                ids.remove(at: index!)
            }
        }
        salvarButton.isEnabled = !ids.isEmpty
    }
    
    func salvar() {
        if let id = self.id, !ids.isEmpty {
            showActivityIndicator()
            let observable = DocumentoService.adicionar(id: id, ids: ids)
            prepare(for: observable)
                .subscribe(
                    onNext: { mobile in
                        if let success = mobile.success, success {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    },
                    onError: { error in
                        self.hideActivityIndicator()
                        self.handle(error)
                    },
                    onCompleted: {
                        self.hideActivityIndicator()
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    @IBAction func onSalvarPressed(_ sender: Any) {
        salvar()
    }
}
