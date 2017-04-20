//
//  ViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 15/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import VMaskTextField

class LoginViewController: NovarViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var cpfTextField: VMaskTextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        checkValidFields()
        cpfTextField.mask = "###.###.###-##"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        entrarButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidFields()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cpfTextField {
            return cpfTextField.shouldChangeCharacters(in: range, replacementString: string)
        }
        return true
    }
    
    // MARK: Actions
    
    @IBAction func onEntrarPressed() {
        if let cpf = cpfTextField.text, let senha = senhaTextField.text {
            showActivityIndicator()
            let observable = LoginService.autenticar(cpf: cpf, senha: senha)
            prepare(for: observable)
                .subscribe(
                    onNext: { usuario in
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            delegate.usuario = usuario
                            var identifier: String
                            if let termo = usuario.termoAceite, termo {
                                identifier = "SWRevealViewController"
                            } else {
                                identifier = "TermoUsoViewController"
                            }
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier)
                            self.present(controller!, animated: true, completion: nil)
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
    
    // MARK: Functions
    func checkValidFields() {
        let cpf = cpfTextField.text ?? ""
        let senha = senhaTextField.text ?? ""
        entrarButton.isEnabled = !cpf.isEmpty && !senha.isEmpty
    }
}

