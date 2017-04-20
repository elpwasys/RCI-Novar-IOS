//
//  ProcessoPesquisaViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 19/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class ProcessoPesquisaViewController: DrawerViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var statusButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var drawerButton: UIBarButtonItem!
    
    var tipo = ProcessoFiltro.Tipo.consulta
    var filtro: ProcessoFiltro!
    var paging = PagingModel<ProcessoModel>()
    
    private var statusLabel = UILabel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        drawerButton.target = revealViewController()
        drawerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        statusLabel.sizeToFit()
        statusLabel.font = statusLabel.font.withSize(14.0)
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = UIColor.clear
        statusButton.customView = statusLabel
        
        tableView.delegate = self
        tableView.dataSource = self
        
        switch tipo {
        case .consulta:
            title = "Consulta"
            filtro = ProcessoFiltro.padrao
        case .liberados:
            title = "Liberados"
            filtro = ProcessoFiltro.padrao
        case .pendencias:
            title = "Pendências"
            filtro = ProcessoFiltro()
        }
        filtro.tipo = tipo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carregar(paging.page)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paging.records.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessoTableViewCell", for: indexPath) as! ProcessoTableViewCell
        let processo = paging.records[indexPath.row]
        cell.popular(processo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let processo = paging.records[indexPath.row]
//        let navigation = self.navigationController!
//        let controller = storyboard?.instantiateViewController(withIdentifier: "processo.detalhe") as! ProcessoDetalheViewController
//        controller.id = processo.id
//        navigation.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Segue.Filtro.Processo" {
                let controller = segue.destination as! ProcessoFiltroViewController
                controller.filtro = filtro
            } else if identifier == "Segue.Detail.Processo" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let processo = paging.records[indexPath.row]
                    let controller = segue.destination as! ProcessoDetalheViewController
                    controller.id = processo.id
                    controller.tipo = .visualizacao
                }
            }
        }
    }
    
    @IBAction func unwindFiltro(segue: UIStoryboardSegue) {
        if let controller = segue.source as? ProcessoFiltroViewController {
            filtro = controller.filtro
            paging.page = 0
            carregar(paging.page)
        }
    }
    
    @IBAction func onRefreshPressed(_ sender: Any) {
        carregar(paging.page)
    }
    
    @IBAction func onNextPressed(_ sender: Any) {
        carregar(paging.page + 1)
    }
    
    @IBAction func onPreviousPressed(_ sender: Any) {
        carregar(paging.page - 1)
    }
    
    func carregar(_ page: Int) {
        let observable = ProcessoService.pesquisar(page: page, filtro: filtro)
        showActivityIndicator()
        prepare(for: observable)
            .subscribe(
                onNext: { paging in
                    self.atualizar(paging)
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
    
    func atualizar(_ paging: PagingModel<ProcessoModel>) {
        self.paging = paging
        if paging.hasNext() {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        if paging.hasPrevious() {
            previousButton.isEnabled = true
        } else {
            previousButton.isEnabled = false
        }
        if paging.qtde > 0 {
            statusLabel.text = "\(paging.page + 1) / \(paging.qtde)"
        } else {
            statusLabel.text = "Sem registros para exibir"
        }
        statusLabel.sizeToFit()
        tableView.reloadData()
    }
}
