//
//  TransformacaoTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 13/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class TransformacaoTableViewCell: UITableViewCell {

    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func popular(_ transformacao: TransformacaoModel) {
        if let empresaTransformadora = transformacao.empresaTransformadora {
            TextUtils.text(empresaTransformadora.razaoSocial, for: descricaoLabel)
            TextUtils.text(transformacao.valor, for: valorLabel)
        }
    }
}
