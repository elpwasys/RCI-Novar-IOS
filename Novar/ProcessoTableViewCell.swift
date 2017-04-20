//
//  ProcessoTableViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 19/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class ProcessoTableViewCell: UITableViewCell {

    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var cpfCnpjLabel: UILabel!
    @IBOutlet weak var veiculoLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func popular(_ processo: ProcessoModel) {
        TextUtils.text(processo.numeroProposta, for: numeroLabel)
        TextUtils.text(processo.nomeFinanciado, for: nomeLabel)
        TextUtils.text(processo.cpfCnpjFinanciado, for: cpfCnpjLabel)
        TextUtils.text(processo.valorFinanciado, for: valorLabel)
        TextUtils.text(processo.dataCriacao, for: dataLabel)
        // Veiculo
        var veiculo = String()
        if let marca = processo.marca, let nome = marca.nome {
            veiculo.append(nome)
        }
        if let modelo = processo.modelo, let nome = modelo.nome {
            if !veiculo.isEmpty {
                veiculo.append(" / ")
            }
            veiculo.append(nome)
        }
        if let fabricacao = processo.anoFabricacao {
            if !veiculo.isEmpty {
                veiculo.append(" / ")
            }
            veiculo.append("\(fabricacao)")
        }
        TextUtils.text(veiculo, for: veiculoLabel)
        if let status = processo.status {
            statusLabel.text = status.label
            statusImageView.image = status.image
        }
    }
}
