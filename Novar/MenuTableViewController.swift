//
//  MenuTableViewController.swift
//  NavigationDrawer
//
//  Created by Everton Luiz Pascke on 18/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var razaoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let usuario = delegate.usuario {
            nomeLabel.text = usuario.nome
            razaoLabel.text = usuario.concessionarias?.first?.razaoSocial
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let controller = navigation.viewControllers.first as? ProcessoPesquisaViewController {
                if let identifier = segue.identifier {
                    switch identifier {
                    case "consulta":
                        controller.tipo = .consulta
                        break
                    case "liberados":
                        controller.tipo = .liberados
                        break
                    case "pendencias":
                        controller.tipo = .pendencias
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 2 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sair", message: "Deseja sair do aplicativo?", preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                    self.sair()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sair() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Login") {
            present(controller, animated: true, completion: nil)
        }
    }
}
