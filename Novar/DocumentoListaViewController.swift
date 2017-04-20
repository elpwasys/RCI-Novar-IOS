//
//  DocumentoListaViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class DocumentoListaViewController: NovarViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var adicionarButton: UIBarButtonItem!
    
    var processo: ProcessoModel?
    
    var editavel = false
    var deletados = [DocumentoModel]()
    var solicitados = [DocumentoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carregar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentoTableViewCell", for: indexPath) as! DocumentoTableViewCell
        let documento = solicitados[indexPath.row]
        cell.popular(documento)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let documento = solicitados[indexPath.row]
        if let status = documento.status, let obrigatorio = documento.obrigatorio {
            if !obrigatorio && DocumentoModel.Status.digitalizando != status {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: TextUtils.localizedString(forKey: "Label.Documento"),
                    message: TextUtils.localizedString(forKey: "Question.DocumentoExcluir"),
                    preferredStyle: UIAlertControllerStyle.actionSheet
                )
                alert.addAction(UIAlertAction(
                    title: TextUtils.localizedString(forKey: "Label.Sim"),
                    style: UIAlertActionStyle.default,
                    handler: { action in
                        self.excluir(forRowAt: indexPath)
                    }
                ))
                alert.addAction(UIAlertAction(
                    title: TextUtils.localizedString(forKey: "Label.Nao"),
                    style: UIAlertActionStyle.cancel,
                    handler: nil
                ))
                self.present(alert, animated: true, completion: nil)
            }
        } else if editingStyle == .insert {
            
        }
    }
    
    func excluir(forRowAt indexPath: IndexPath) {
        if let id = solicitados[indexPath.row].id {
            showActivityIndicator()
            let observable = DocumentoService.excluir(id: id)
            prepare(for: observable)
                .subscribe(
                    onNext: { dataMobile in
                        if dataMobile.success! {
                            self.carregar()
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldPerformSegue = false
        switch identifier {
        case "documento.edicao":
            if let selectedCell = sender as? DocumentoTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let documento = solicitados[indexPath.row]
                if let status = documento.status {
                    if status == .digitalizando {
                        handle(Throuble(TextUtils.localizedString(forKey: "Message.AguardandoDigitalizacao")))
                    } else if status == .erroDigitalizacao {
                        handleErroDocumentoPressed(documento: documento)
                    } else {
                        shouldPerformSegue = true
                    }
                }
            }
        default:
            shouldPerformSegue = true
        }
        return shouldPerformSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "documento.opcional" {
            let controller = segue.destination as! OpcionalViewController
            controller.id = processo?.id
            controller.deletados = deletados
        } else if identifier == "documento.edicao" {
            let controller = segue.destination as! DocumentoViewController
            if let selectedCell = sender as? DocumentoTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)!
                let documento = solicitados[indexPath.row]
                controller.processo = processo
                controller.documento = documento
            }
        }
        //
    }
    
    func handleErroDocumentoPressed(documento: DocumentoModel) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localizedString(forKey: "Label.Documento"),
                message: TextUtils.localizedString(forKey: "Question.DocumentoErro"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Reenviar"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.reenviar(documento: documento)
            }
            ))
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Fechar"),
                style: UIAlertActionStyle.cancel,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func carregar() {
        if let id = processo?.id {
            showActivityIndicator()
            let observable = DocumentoService.buscar(processoId: id)
            prepare(for: observable)
                .subscribe(
                    onNext: { documentos in
                        self.atualizar(documentos: documentos)
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
    
    func atualizar(documentos: DocumentosModel) {
        if let solicitados = documentos.solicitados {
            self.solicitados = solicitados
        } else {
            self.solicitados = [DocumentoModel]()
        }
        tableView.reloadData()
        if let finalizavel = documentos.finalizavel {
            enviarButton.isHidden = !finalizavel
        }
        deletados.removeAll()
        if let deletados = documentos.deletados, !deletados.isEmpty {
            self.deletados = deletados
        }
        adicionarButton.isEnabled = !self.deletados.isEmpty
    }
    
    private func reenviar(documento: DocumentoModel) {
        if let documentoId = documento.id {
            do {
                try ImagemService.digitalizar(documentoId: documentoId);
                carregar()
            } catch {
                handle(error)
            }
        }
    }
    
    private func enviar() {
        if let id = processo?.id {
            showActivityIndicator()
            let observable = ProcessoService.finalizar(id: id)
            prepare(for: observable)
                .subscribe(
                    onNext: { mobile in
                        if let success = mobile.success, let message = mobile.message, success {
                            self.view.makeToast(message: message)
                            self.carregar()
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
    
    @IBAction func onAtualizarPressed(_ sender: Any) {
        carregar()
    }

    @IBAction func onEnviarPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localizedString(forKey: "Label.Conferencia"),
                message: TextUtils.localizedString(forKey: "Question.ProcessoFinalizar"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.enviar()
            }
            ))
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Nao"),
                style: UIAlertActionStyle.cancel,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
