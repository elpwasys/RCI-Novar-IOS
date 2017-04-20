//
//  ProcessoLegendaTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 09/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class ProcessoLegendaTableViewCell: UITableViewCell {

    @IBOutlet weak var icone: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func popular(_ status: ProcessoModel.Status) {
        label.text = status.label
        icone.image = status.image
    }
}
