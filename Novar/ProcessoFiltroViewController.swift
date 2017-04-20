//
//  ProcessoFiltroViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 21/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import VMaskTextField

class ProcessoFiltroViewController: AppViewController, UITextFieldDelegate {
    
    @IBOutlet weak var deDateField: DateField!
    @IBOutlet weak var ateDateField: DateField!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var statusPickerField: PickerField!
    @IBOutlet weak var pessoaSegment: UISegmentedControl!
    @IBOutlet weak var cpfCnpjTextField: VMaskTextField!
    
    var filtro: ProcessoFiltro!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cpfCnpjTextField.delegate = self
        cpfCnpjTextField.isEnabled = false
        
        statusPickerField.isRequired = false
        statusPickerField.entries(array: ProcessoModel.Status.values)
        
        if filtro != nil {
            TextUtils.text(filtro.periodoDe, for: deDateField)
            TextUtils.text(filtro.periodoAte, for: ateDateField)
            TextUtils.text(filtro.numeroOrcamento, for: numeroTextField)
            if let pessoa = filtro.pessoa {
                switch pessoa {
                case .fisica:
                    pessoaSegment.selectedSegmentIndex = 0
                case .juridica:
                    pessoaSegment.selectedSegmentIndex = 1
                }
                onPessoaChange(pessoaSegment)
                TextUtils.text(filtro.cpfCnpj, for: cpfCnpjTextField)
            } else {
                cpfCnpjTextField.text = nil
                cpfCnpjTextField.isEnabled = false
            }
            var value: Selectable?
            if filtro.tipo == ProcessoFiltro.Tipo.pendencias {
                value = ProcessoModel.Status.pendente
                statusPickerField.isEnabled = false
            } else if filtro.tipo == ProcessoFiltro.Tipo.liberados {
                value = ProcessoModel.Status.liberado
                statusPickerField.isEnabled = false
            } else if let status = filtro.status {
                value = status
            }
            statusPickerField.value = value
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPessoaChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            cpfCnpjTextField.mask = "###.###.###-##"
            cpfCnpjTextField.placeholder = "CPF"
            filtro.pessoa = .fisica
        } else {
            cpfCnpjTextField.mask = "##.###.###.####-##"
            cpfCnpjTextField.placeholder = "CNPJ"
            filtro.pessoa = .juridica
        }
        cpfCnpjTextField.text = nil
        cpfCnpjTextField.isEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cpfCnpjTextField {
            return cpfCnpjTextField.shouldChangeCharacters(in: range, replacementString: string)
        }
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        filtro.status = statusPickerField.value as! ProcessoModel.Status?
        filtro.cpfCnpj = cpfCnpjTextField.text
        filtro.numeroOrcamento = numeroTextField.text
        filtro.periodoDe = deDateField.date
        filtro.periodoAte = ateDateField.date
    }
}
