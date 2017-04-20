//
//  ProcessoCadastroViewController.swift
//  NavigationDrawer
//
//  Created by Everton Luiz Pascke on 18/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class ProcessoCadastroViewController: DrawerViewController, UITextFieldDelegate {

    @IBOutlet weak var buscarButton: UIButton!
    @IBOutlet weak var pickerField: PickerField!
    @IBOutlet weak var drawerButton: UIBarButtonItem!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var dataPropostaDateField: DateField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawerButton.target = revealViewController()
        drawerButton.action = #selector(SWRevealViewController.revealToggle(_:))
        pickerField.entries(array: concessionarias)
        numeroTextField.delegate = self
        dataPropostaDateField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        buscarButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buscarButton.isEnabled = isValid()
    }
    
    @IBAction func onBuscarPressed() {
        let numero = numeroTextField.text!
        let dataProposta = dataPropostaDateField.date!
        let concessionaria = pickerField.value as! ConcessionariaModel
        let concessionariaId = concessionaria.id!
        showActivityIndicator()
        let observable = ProcessoService.buscar(concessionariaId: concessionariaId, numeroOrcamento: numero, dataProposta: dataProposta)
        prepare(for: observable)
            .subscribe(
                onNext: { processo in
                    self.pushDetalheViewController(id: processo.id!)
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
    
    func pushDetalheViewController(id: Int) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Detail.Processo") as? ProcessoDetalheViewController {
            controller.id = id
            controller.tipo = .visualizacao
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func isValid() -> Bool {
        if pickerField.value == nil {
            return false
        }
        let numero = numeroTextField.text ?? ""
        if numero.isEmpty {
            return false
        }
        if dataPropostaDateField.date == nil {
            return false
        }
        return true
    }
}
