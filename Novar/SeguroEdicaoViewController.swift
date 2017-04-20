//
//  SeguroEdicaoViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 05/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class SeguroEdicaoViewController: NovarViewController {

    @IBOutlet weak var seguroField: PickerField!
    @IBOutlet weak var valorField: DecimalField!
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    
    var seguros: [Option]?
    var seguroDocumento: SeguroDocumentoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seguroField.entries(array: seguros)
        if let seguroDocumento = self.seguroDocumento {
            seguroField.value = seguroDocumento.seguro
            TextUtils.text(seguroDocumento.documento?.valorSeguro, for: valorField)
        }
        salvarButton.isEnabled = isValid()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onDidEndEditing() {
        salvarButton.isEnabled = isValid()
    }
    
    @IBAction func onDidBeginEditing() {
        salvarButton.isEnabled = false
    }
    
    private func isValid() -> Bool {
        if seguroField.value == nil {
            return false
        }
        if valorField.value == nil {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem, sender === salvarButton {
            if seguroDocumento == nil {
                seguroDocumento = SeguroDocumentoModel()
            }
            let seguro = SeguroModel()
            seguro.id = Int((seguroField.value?.value)!)
            seguro.descricao = seguroField.value?.label
            let documento = DocumentoModel()
            documento.valorSeguro = valorField.value
            seguroDocumento?.seguro = seguro
            seguroDocumento?.documento = documento
        }
    }
}
