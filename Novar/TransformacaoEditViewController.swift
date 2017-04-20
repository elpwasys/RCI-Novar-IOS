//
//  TransformacaoEditViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 05/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class TransformacaoEditViewController: NovarViewController {
    
    @IBOutlet weak var valorField: DecimalField!
    @IBOutlet weak var salvarButton: UIBarButtonItem!
    @IBOutlet weak var transformacaoField: PickerField!
    
    var empresas: [Option]?
    var transformacao: TransformacaoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transformacaoField.entries(array: empresas)
        if let transformacao = self.transformacao {
            transformacaoField.value = transformacao.empresaTransformadora
            TextUtils.text(transformacao.valor, for: valorField)
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
        if transformacaoField.value == nil {
            return false
        }
        if valorField.value == nil {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem, sender === salvarButton {
            if transformacao == nil {
                transformacao = TransformacaoModel()
            }
            let empresaTransformadora = EmpresaTransformadoraModel()
            empresaTransformadora.id = Int((transformacaoField.value?.value)!)
            empresaTransformadora.razaoSocial = transformacaoField.value?.label
            transformacao?.valor = valorField.value
            transformacao?.empresaTransformadora = empresaTransformadora
        }
    }
}
