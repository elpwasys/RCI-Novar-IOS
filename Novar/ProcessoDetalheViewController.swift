//
//  ProcessoDetalheViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 16/11/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

import Alamofire
import ObjectMapper

class ProcessoDetalheViewController: DrawerViewController, PickerFieldDelegate {
    
    @IBOutlet weak var concessionariaLabel: UILabel!
    @IBOutlet weak var dataPropostaLabel: UILabel!
    @IBOutlet weak var numeroPropostaLabel: UILabel!
    @IBOutlet weak var contaLabel: UILabel!
    @IBOutlet weak var tipoVendaLabel: UILabel!
    @IBOutlet weak var possuiBoletoLabel: UILabel!
    @IBOutlet weak var numeroBoletoLabel: UILabel!
    @IBOutlet weak var valorBoletoLabel: UILabel!
    @IBOutlet weak var vencimentoBoletoLabel: UILabel!
    @IBOutlet weak var marcaLabel: UILabel!
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var versaoLabel: UILabel!
    @IBOutlet weak var codigoOperadorLabel: UILabel!
    @IBOutlet weak var ufEmplacamentoLabel: UILabel!
    @IBOutlet weak var nomeAvalistaLabel: UILabel!
    @IBOutlet weak var cpfAvalistaLabel: UILabel!
    @IBOutlet weak var documentosLabel: UILabel!
    @IBOutlet weak var pendenciasLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tipoProcessoTextField: UITextField!
    @IBOutlet weak var dataCriacaoDateField: DateField!
    @IBOutlet weak var concessionariaField: PickerField!
    @IBOutlet weak var numeroOrcamentoTextField: UITextField!
    @IBOutlet weak var dataPropostaDateField: DateField!
    @IBOutlet weak var valorAprovacaoTextField: UITextField!
    @IBOutlet weak var numeroPropostaTextField: UITextField!
    @IBOutlet weak var produtoTextField: UITextField!
    @IBOutlet weak var situacaoTextField: UITextField!
    @IBOutlet weak var valorFinanciadoTextField: UITextField!
    @IBOutlet weak var codigoTabelaTextField: UITextField!
    @IBOutlet weak var chassiTextField: UITextField!
    @IBOutlet weak var contaField: PickerField!
    @IBOutlet weak var perfilClienteTextField: UITextField!
    @IBOutlet weak var tipoVendaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var possuiBoletoSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numeroBoletoTextField: UITextField!
    @IBOutlet weak var valorBoletoDecimalField: DecimalField!
    @IBOutlet weak var vencimentoBoletoDateField: DateField!
    @IBOutlet weak var marcaField: PickerField!
    @IBOutlet weak var modeloField: PickerField!
    @IBOutlet weak var versaoField: PickerField!
    @IBOutlet weak var anoFabricacaoTextField: UITextField!
    @IBOutlet weak var anoVersaoTextField: UITextField!
    @IBOutlet weak var nomeFinanciadoTextField: UITextField!
    @IBOutlet weak var cpfFinanciadoTextField: UITextField!
    @IBOutlet weak var codigoOperadorTextField: UITextField!
    @IBOutlet weak var codigoVendedorTextField: UITextField!
    @IBOutlet weak var ufEmplacamentoTexField: UITextField!
    @IBOutlet weak var possuiAvalistaSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nomeAvalistaTextField: UITextField!
    @IBOutlet weak var cpfAvalistaTextField: UITextField!
    @IBOutlet weak var valorAcessoriaDecimalField: DecimalField!
    @IBOutlet weak var descricaoAcessoriosTextField: UITextField!
    
    @IBOutlet weak var salvarButton: UIButton!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var editarButton: UIBarButtonItem!
    
    var id: Int?
    var tipo = Tipo.visualizacao
    var response: ProcessoResponse?
    
    enum Tipo {
        case edicao
        case visualizacao
    }
    
    var isEnable = false {
        didSet {
            tipo = isEnable ? .edicao : .visualizacao
            // Enable/Disable UI
            concessionariaField.isEnabled = isEnable
            numeroOrcamentoTextField.isEnabled = isEnable
            dataPropostaDateField.isEnabled = isEnable
            numeroPropostaTextField.isEnabled = isEnable
            contaField.isEnabled = isEnable
            tipoVendaSegmentedControl.isEnabled = isEnable
            marcaField.isEnabled = isEnable
            modeloField.isEnabled = isEnable
            versaoField.isEnabled = isEnable
            codigoOperadorTextField.isEnabled = isEnable
            codigoVendedorTextField.isEnabled = isEnable
            ufEmplacamentoTexField.isEnabled = isEnable
            possuiAvalistaSegmentedControl.isEnabled = isEnable
            valorAcessoriaDecimalField.isEnabled = isEnable
            descricaoAcessoriosTextField.isEnabled = isEnable
            // Setting text and colors required UILabel
            let labels: [UILabel] = [
                concessionariaLabel,
                dataPropostaLabel,
                numeroPropostaLabel,
                contaLabel,
                tipoVendaLabel,
                possuiBoletoLabel,
                numeroBoletoLabel,
                valorBoletoLabel,
                vencimentoBoletoLabel,
                marcaLabel,
                modeloLabel,
                versaoLabel,
                codigoOperadorLabel,
                ufEmplacamentoLabel,
                nomeAvalistaLabel,
                cpfAvalistaLabel
            ]
            let required = " *"
            if (isEnable) {
                for label in labels {
                    label.text = "\(label.text!)\(required)"
                    label.textColor = UIColor.red
                }
            } else {
                for label in labels {
                    let text = label.text!
                    label.text = text.replacingOccurrences(of: required, with: "")
                    label.textColor = UIColor.black
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marcaField.pickerDelegate = self
        modeloField.pickerDelegate = self
        versaoField.pickerDelegate = self
        concessionariaField.pickerDelegate = self
        carregar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue.List.Seguro" {
            let controller = segue.destination as! SeguroListaViewController
            controller.isEdit = isEnable
            controller.response = response
        } else if segue.identifier == "Segue.List.Transformacao" {
            let controller = segue.destination as! TransformacaoListViewController
            controller.isEdit = isEnable
            controller.response = response
        } else if segue.identifier == "Segue.List.Documento" {
            let controller = StoryboardUtils.controller(for: segue) as! DocumentoListaViewController
            controller.processo = response?.processo
        }
    }
    
    func pickerField(_ pickerField: PickerField, selected: Selectable?) {
        if pickerField == concessionariaField {
            let concessionariaId: Int? = {
                if let option = concessionariaField.value, let id = Int(option.value) {
                    return id
                }
                return nil
            }()
            listar(concessionariaId: concessionariaId)
        } else if pickerField == marcaField {
            let marcaId: Int? = {
                if let option = marcaField.value, let id = Int(option.value) {
                    return id
                }
                return nil
            }()
            listar(marcaId: marcaId)
        } else if pickerField == modeloField {
            let marcaId: Int? = {
                if let option = marcaField.value, let id = Int(option.value) {
                    return id
                }
                return nil
            }()
            let modeloId: Int? = {
                if let option = modeloField.value, let id = Int(option.value) {
                    return id
                }
                return nil
            }()
            listar(marcaId: marcaId, modeloId: modeloId)
        }
    }
    
    private func carregar() {
        if let id = id {
            showActivityIndicator()
            let observable = ProcessoService.carregar(id: id, edicao: (tipo == .edicao))
            prepare(for: observable).subscribe(
                onNext: { response in
                    self.popular(response: response)
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
    
    private func popular(response: ProcessoResponse) {
        self.response = response
        enviarButton.isHidden = true
        editarButton.isEnabled = false
        var documentos = 0
        if response.documentos != nil {
            documentos = response.documentos!
        }
        documentosLabel.text = "\(documentos) \(TextUtils.localizedString(forKey: "Label.Documentos"))"
        var pendencias = 0
        if response.pendencias != nil {
            pendencias = response.pendencias!
        }
        pendenciasLabel.text = "\(pendencias) \(TextUtils.localizedString(forKey: "Label.Pendencias"))"
        if let processo = response.processo {
            TextUtils.text(processo.status?.label, for: statusLabel)
            TextUtils.text(processo.tipoProcesso?.nome, for: tipoProcessoTextField)
            TextUtils.text(processo.dataCriacao, for: dataCriacaoDateField)
            TextUtils.text(processo.numeroOrcamento, for: numeroOrcamentoTextField)
            TextUtils.text(processo.dataProposta, for: dataPropostaDateField)
            TextUtils.text(processo.valorAprovacao, for: valorAprovacaoTextField)
            TextUtils.text(processo.numeroProposta, for: numeroPropostaTextField)
            TextUtils.text(processo.produto?.label, for: produtoTextField)
            TextUtils.text(processo.situacaoVeiculo?.label, for: situacaoTextField)
            TextUtils.text(processo.valorFinanciado, for: valorFinanciadoTextField)
            TextUtils.text(processo.codigoTabela, for: codigoTabelaTextField)
            TextUtils.text(processo.chassi, for: chassiTextField)
            TextUtils.text(processo.perfilCliente?.label, for: perfilClienteTextField)
            tipoVendaSegmentedControl.selectedSegmentIndex = {
                guard let tipoVenda = processo.tipoVenda else {
                    return UISegmentedControlNoSegment
                }
                return ProcessoModel.TipoVenda.values.index(of: tipoVenda)!
            }()
            possuiBoletoSegmentedControl.selectedSegmentIndex = {
                guard let possuiBoleto = processo.possuiBoleto else {
                    return 1
                }
                return possuiBoleto ? 0 : 1
            }()
            TextUtils.text(processo.numeroBoleto, for: numeroBoletoTextField)
            TextUtils.text(processo.valorBoleto, for: valorBoletoDecimalField)
            TextUtils.text(processo.vencimentoBoleto, for: vencimentoBoletoDateField)
            tipoVendaValueChanged()
            TextUtils.text(processo.anoFabricacao, for: anoFabricacaoTextField)
            TextUtils.text(processo.anoVersao, for: anoVersaoTextField)
            TextUtils.text(processo.nomeFinanciado, for: nomeFinanciadoTextField)
            TextUtils.text(processo.cpfCnpjFinanciado, for: cpfFinanciadoTextField)
            TextUtils.text(processo.codigoOperador, for: codigoOperadorTextField)
            TextUtils.text(processo.codigoVendedor, for: codigoVendedorTextField)
            TextUtils.text(processo.ufEmplacamento, for: ufEmplacamentoTexField)
            possuiAvalistaSegmentedControl.selectedSegmentIndex = {
                guard let possuiAvalista = processo.possuiAvalista else {
                    return 1
                }
                return possuiAvalista ? 0 : 1
            }()
            possuiAvalistaValueChanged()
            TextUtils.text(processo.nomeAvalista, for: nomeAvalistaTextField)
            TextUtils.text(processo.cpfAvalista, for: cpfAvalistaTextField)
            TextUtils.text(processo.valorAcessorios, for: valorAcessoriaDecimalField)
            TextUtils.text(processo.justificativaAcessorios, for: descricaoAcessoriosTextField)
            concessionariaField.entries(array: concessionarias)
            concessionariaField.value = processo.concessionaria
            marcaField.value = processo.marca
            modeloField.value = processo.modelo
            versaoField.value = processo.versao
            contaField.value = processo.conta
            if processo.marca == nil {
                listar()
            }
            if let contas = response.contas {
                contaField.entries(array: contas)
            }
            if let editavel = processo.editavel {
                editarButton.isEnabled = editavel
            }
            if let finalizavel = processo.finalizavel {
                enviarButton.isHidden = !finalizavel
            }
        }
    }
    
    private func setEnable(_ enable: Bool) {
        isEnable = enable
        editarButton.title = TextUtils.localizedString(forKey: "Label.\(isEnable ? "Cancelar" : "Editar")")
        carregar()
        salvarButton.isHidden = !enable
    }
    
    private func listar() {
        marcaField.clear()
        modeloField.clear()
        versaoField.clear()
        if let id = self.id {
            let observable = MarcaService.listar(processoId: id)
            let setEnable = { (_ isEnabled: Bool) in
                self.marcaField.isEnabled = isEnabled
                self.modeloField.isEnabled = isEnabled
                self.versaoField.isEnabled = isEnabled
            }
            setEnable(false)
            prepare(for: observable)
                .subscribe(
                    onNext: { options in
                        self.marcaField.entries(array: options)
                    },
                    onError: { error in
                        self.handle(error)
                        setEnable(true)
                    },
                    onCompleted: {
                        setEnable(true)
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    private func listar(marcaId: Int?) {
        modeloField.clear()
        versaoField.clear()
        if let id = self.id, let marcaId = marcaId {
            let observable = ModeloService.listar(processoId: id, marcaId: marcaId)
            let setEnable = { (_ isEnabled: Bool) in
                self.modeloField.isEnabled = isEnabled
                self.versaoField.isEnabled = isEnabled
            }
            setEnable(false)
            prepare(for: observable)
                .subscribe(
                    onNext: { options in
                        self.modeloField.entries(array: options)
                    },
                    onError: { error in
                        self.handle(error)
                        setEnable(true)
                    },
                    onCompleted: {
                        setEnable(true)
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    private func listar(marcaId: Int?, modeloId: Int?) {
        versaoField.clear()
        if let id = self.id, let marcaId = marcaId, let modeloId = modeloId {
            let observable = VersaoService.listar(processoId: id, marcaId: marcaId, modeloId: modeloId)
            let setEnable = { (_ isEnabled: Bool) in
                self.versaoField.isEnabled = isEnabled
            }
            setEnable(false)
            prepare(for: observable)
                .subscribe(
                    onNext: { options in
                        self.versaoField.entries(array: options)
                    },
                    onError: { error in
                        self.handle(error)
                        setEnable(true)
                    },
                    onCompleted: {
                        setEnable(true)
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    private func listar(concessionariaId: Int?) {
        contaField.clear()
        if let concessionariaId = concessionariaId {
            let observable = ContaProcessoService.listar(concessionariaId: concessionariaId)
            let setEnable = { (_ isEnabled: Bool) in
                self.contaField.isEnabled = isEnabled
            }
            setEnable(false)
            prepare(for: observable)
                .subscribe(
                    onNext: { options in
                        self.contaField.entries(array: options)
                    },
                    onError: { error in
                        self.handle(error)
                        setEnable(true)
                    },
                    onCompleted: {
                        setEnable(true)
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    private func salvar() {
        guard let processo = self.response?.processo else {
            return
        }
        let isValid = validate()
        if isValid {
            let request = ProcessoRequest(processo.id)
            request.contaId = NumberUtils.parse(contaField.value?.value)
            request.marcaId = NumberUtils.parse(marcaField.value?.value)
            request.modeloId = NumberUtils.parse(modeloField.value?.value)
            request.versaoId = NumberUtils.parse(versaoField.value?.value)
            request.concessionariaId = NumberUtils.parse(concessionariaField.value?.value)
            request.dataProposta = dataPropostaDateField.date
            if tipoVendaSegmentedControl.selectedSegmentIndex == 0 && possuiBoletoSegmentedControl.selectedSegmentIndex == 0 {
                request.numeroBoleto = NumberUtils.parse(numeroBoletoTextField.text)
                request.valorBoleto = valorBoletoDecimalField.value
                request.vencimentoBoleto = vencimentoBoletoDateField.date
            }
            request.codigoOperador = codigoOperadorTextField.text
            request.codigoVendedor = codigoVendedorTextField.text
            request.ufEmplacamento = ufEmplacamentoTexField.text
            request.numeroProposta = numeroPropostaTextField.text
            request.numeroOrcamento = numeroOrcamentoTextField.text
            request.cpfCnpjFinanciado = cpfFinanciadoTextField.text
            request.justificativaAcessorios = descricaoAcessoriosTextField.text
            if possuiAvalistaSegmentedControl.selectedSegmentIndex == 0 {
                request.cpfAvalista = cpfAvalistaTextField.text
                request.nomeAvalista = nomeAvalistaTextField.text
            }
            request.valorAcessorios = valorAcessoriaDecimalField.value
            request.tipoVenda = {
                switch tipoVendaSegmentedControl.selectedSegmentIndex {
                case 0:
                    return .direta
                case 1:
                    return .eCommerce
                case 2:
                    return .outro
                default:
                    return nil
                }
            }()
            request.perfilCliente = processo.perfilCliente
            if let rows = processo.segurosDocumentos, !rows.isEmpty {
                var seguros = [KeyValue]()
                for row in rows {
                    if let id = row.seguro?.id, let value = row.documento?.valorSeguro {
                        seguros.append(KeyValue(key: "\(id)", value: "\(value)"))
                    }
                }
                request.seguros = seguros
            }
            if let rows = processo.transformacoes, !rows.isEmpty {
                var transformacoes = [KeyValue]()
                for row in rows {
                    if let id = row.empresaTransformadora?.id, let value = row.valor {
                        transformacoes.append(KeyValue(key: "\(id)", value: "\(value)"))
                    }
                }
                request.transformacoes = transformacoes
            }
            showActivityIndicator()
            let observable = ProcessoService.salvar(request: request)
            prepare(for: observable)
                .subscribe(
                    onNext: { mobile in
                        if let success = mobile.success, let message = mobile.message, success {
                            self.view.makeToast(message: message)
                            self.setEnable(false)
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
    
    private func enviar() {
        if let processo = response?.processo, let id = processo.id {
            showActivityIndicator()
            let observable = ProcessoService.finalizar(id: id)
            prepare(for: observable)
                .subscribe(
                    onNext: { mobile in
                        if let success = mobile.success, let message = mobile.message, success {
                            self.view.makeToast(message: message)
                            _ = self.navigationController?.popViewController(animated: true)
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
    
    private func validate() -> Bool {
        var dictionary: [UIView: String] = [
            concessionariaField: "Label.Concessionaria",
            dataPropostaDateField: "Label.DataProposta",
            numeroPropostaTextField: "Label.NumeroProposta",
            contaField: "Label.Conta",
            marcaField: "Label.Marca",
            modeloField: "Label.Modelo",
            versaoField: "Label.Versao",
            codigoOperadorTextField: "Label.CodigoOperador",
            ufEmplacamentoTexField: "Label.UFEmplacamento"
        ]
        var errors = [String]()
        if tipoVendaSegmentedControl.selectedSegmentIndex == 0 && possuiBoletoSegmentedControl.selectedSegmentIndex == 0 {
            dictionary[numeroBoletoTextField] = "Label.NumeroBoleto"
            dictionary[valorBoletoDecimalField] = "Label.ValorBoleto"
            dictionary[vencimentoBoletoDateField] = "Label.VencimentoBoleto"
        }
        if possuiAvalistaSegmentedControl.selectedSegmentIndex == 0 {
            dictionary[nomeAvalistaTextField] = "Label.NomeAvalista"
            dictionary[cpfAvalistaTextField] = "Label.CPFAvalista"
        }
        for (key, value) in dictionary {
            if let field = key as? PickerField {
                if field.value == nil {
                    let label = TextUtils.localizedString(forKey: value)
                    errors.append("\(label) é obrigatório")
                }
            } else if let field = key as? DateField {
                if field.date == nil {
                    let label = TextUtils.localizedString(forKey: value)
                    errors.append("\(label) é obrigatório")
                }
            } else if let field = key as? UITextField {
                if let text = field.text, text.isEmpty {
                    let label = TextUtils.localizedString(forKey: value)
                    errors.append("\(label) é obrigatório")
                }
            }
        }
        if errors.isEmpty {
            return true
        } else {
            var message = String()
            for (index, error) in errors.enumerated() {
                if index > 0 {
                    message.append("\n")
                }
                message.append(error)
            }
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: TextUtils.localizedString(forKey: "Label.Processo"),
                    message: message,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(
                    title: TextUtils.localizedString(forKey: "Label.Fechar"),
                    style: UIAlertActionStyle.default,
                    handler: nil
                ))
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
    }
    
    @IBAction func tipoVendaValueChanged() {
        var isEnable = false
        if self.isEnable && tipoVendaSegmentedControl.selectedSegmentIndex == 0 {
            isEnable = true
        }
        possuiBoletoSegmentedControl.isEnabled = isEnable
        if isEnable {
           possuiBoletoValueChanged()
        } else {
            numeroBoletoTextField.isEnabled = false
            valorBoletoDecimalField.isEnabled = false
            vencimentoBoletoDateField.isEnabled = false
        }
    }
    
    @IBAction func possuiBoletoValueChanged() {
        var isEnable = false
        if self.isEnable && possuiBoletoSegmentedControl.selectedSegmentIndex == 0 {
            isEnable = true
        }
        numeroBoletoTextField.isEnabled = isEnable
        valorBoletoDecimalField.isEnabled = isEnable
        vencimentoBoletoDateField.isEnabled = isEnable
    }
    
    @IBAction func possuiAvalistaValueChanged() {
        var isEnable = false
        if self.isEnable && possuiAvalistaSegmentedControl.selectedSegmentIndex == 0 {
            isEnable = true
        }
        nomeAvalistaTextField.isEnabled = isEnable
        cpfAvalistaTextField.isEnabled = isEnable
    }
    
    @IBAction func onEditarPressed(_ sender: UIBarButtonItem) {
        if isEnable {
            self.setEnable(false)
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: TextUtils.localizedString(forKey: "Label.Processo"),
                    message: TextUtils.localizedString(forKey: "Question.ProcessoEdicao"),
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(
                    title: TextUtils.localizedString(forKey: "Label.Nao"),
                    style: UIAlertActionStyle.cancel,
                    handler: nil
                ))
                alert.addAction(UIAlertAction(
                    title: TextUtils.localizedString(forKey: "Label.Sim"),
                    style: UIAlertActionStyle.default,
                    handler: { (action: UIAlertAction!) in
                        self.setEnable(true)
                    }
                ))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onSalvarPressed() {
        salvar()
    }
    
    @IBAction func onEnviarPressed() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localizedString(forKey: "Label.Conferencia"),
                message: TextUtils.localizedString(forKey: "Question.ProcessoFinalizar"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    self.enviar()
                }
            ))
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Nao"),
                style: UIAlertActionStyle.cancel,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToJustificativa(sender: UIStoryboardSegue) {
        self.carregar()
    }
}
