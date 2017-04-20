//
//  JustificativaViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 13/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class JustificativaViewController: NovarViewController, UITextViewDelegate {

    @IBOutlet weak var label: Label!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    var documento: DocumentoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        salvarButton.isEnabled = isValid()
        if let documento = self.documento, let pendencia = documento.pendencia {
            label.text = pendencia.observacao
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        salvarButton.isEnabled = isValid()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        salvarButton.isEnabled = false
    }
    
    private func isValid() -> Bool {
        return !textView.text.isEmpty
    }
    
    private func salvar() {
        if let id = self.documento?.id {
            showActivityIndicator()
            let observable = DocumentoService.justificar(documentoId: id, justificativa: textView.text)
            prepare(for: observable)
                .subscribe(
                    onNext: { mobile in
                        if let success = mobile.success, success {
                            self.performSegue(withIdentifier: "Unwind.Detail.Processo", sender: self)
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
        self.salvar()
    }
}
