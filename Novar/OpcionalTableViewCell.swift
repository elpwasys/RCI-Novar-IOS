//
//  OpcionalTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

protocol OptionalTableViewCellDelegate {
    func onSwitchChange(isOn: Bool, id: Int)
}

class OpcionalTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var opcaoSwitch: UISwitch!
    
    var delegate: OptionalTableViewCellDelegate?
    
    var documento: DocumentoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func popular(_ documento: DocumentoModel) {
        self.documento = documento
        TextUtils.text(documento.nome, for: nomeLabel)
    }
    
    
    @IBAction func onSwitchChange(_ sender: UISwitch) {
        if let delegate = self.delegate, let id = documento?.id {
            delegate.onSwitchChange(isOn: sender.isOn, id: id)
        }
    }
}
