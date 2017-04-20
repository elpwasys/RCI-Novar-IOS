//
//  DocumentoTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class DocumentoTableViewCell: UITableViewCell {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var irregularidadeLabel: UILabel!
    @IBOutlet weak var observacaoLabel: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var irregularidadeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func popular(_ documento: DocumentoModel) {
        TextUtils.text(documento.nome, for: nomeLabel)
        TextUtils.text(documento.status?.label, for: statusLabel)
        statusImage.image = documento.status?.image
        if let pendencia = documento.pendencia, let irregularidade = pendencia.irregularidade {
            irregularidadeImage.isHidden = false
            TextUtils.text(irregularidade.descricao, for: irregularidadeLabel)
            TextUtils.text(pendencia.observacao, for: observacaoLabel)
        }
    }
}
