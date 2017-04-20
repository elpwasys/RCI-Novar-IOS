//
//  SeguroDocumentoTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 05/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class SeguroDocumentoTableViewCell: UITableViewCell {

    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func popular(_ seguroDocumento: SeguroDocumentoModel) {
        if let seguro = seguroDocumento.seguro, let documento = seguroDocumento.documento {
            TextUtils.text(seguro.descricao, for: descricaoLabel)
            TextUtils.text(documento.valorSeguro, for: valorLabel)
        }
    }
}
