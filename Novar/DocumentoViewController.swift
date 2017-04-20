//
//  DocumentoViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 21/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import TOCropViewController

class DocumentoViewController: NovarViewController,
    UICollectionViewDelegate, UICollectionViewDataSource, TOCropViewControllerDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImagemCollectionViewCellDelegate {

    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var irregularidadeLabel: UILabel!
    @IBOutlet weak var observacaoLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var irregularidadeImage: UIImageView!
    
    @IBOutlet weak var salvarButton: UIButton!
    @IBOutlet weak var capturarButton: UIButton!
    @IBOutlet weak var justificarButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var processo: ProcessoModel?
    var documento: DocumentoModel?
    var imagePicker: UIImagePickerController!
    
    var imagens = [ImagemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        popular()
        listar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImagemCollectionViewCell, let controller = segue.destination as? ImageViewController  {
            if let data = cell.data {
                controller.data = data
            }
        } else if segue.identifier == "Segue.Justificativa" {
            let controller = segue.destination as! JustificativaViewController
            controller.documento = documento
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagemCollectionViewCell", for: indexPath) as! ImagemCollectionViewCell
        let imagem = imagens[indexPath.row]
        var editavel = false
        if let digitalizavel = documento?.digitalizavel {
            editavel = digitalizavel
        }
        cell.popular(imagem: imagem, editavel: editavel)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        display(position: indexPath.row)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let controller = TOCropViewController(image: image)
            controller.delegate = self
            if let documento = self.documento, let width = documento.largura, let height = documento.altura {
                controller.aspectRatioLockEnabled = true
                controller.customAspectRatio = CGSize(width: width, height: height)
            }
            controller.aspectRatioPickerButtonHidden = true
            present(controller, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        salvar(image: image)
    }
    
    func popular() {
        if let processo = self.processo, let documento = self.documento {
            self.title = documento.nome
            TextUtils.text(processo.numeroProposta, for: numeroLabel)
            TextUtils.text(documento.status?.label, for: statusLabel)
            statusImage.image = documento.status?.image
            if let pendencia = documento.pendencia, let irregularidade = pendencia.irregularidade {
                TextUtils.text(pendencia.observacao, for: observacaoLabel)
                TextUtils.text(irregularidade.descricao, for: irregularidadeLabel)
                observacaoLabel.isHidden = false
                justificarButton.isHidden = false
                irregularidadeLabel.isHidden = false
                irregularidadeImage.isHidden = false
            }
            if let digitalizavel = documento.digitalizavel {
                salvarButton.isHidden = !digitalizavel
                capturarButton.isHidden = !digitalizavel
            }
        }
    }
    
    func display(position: Int) {
        var size = 0
        var page = 0
        if imagens.count > 0 {
            page = position + 1
            size = imagens.count
        }
        TextUtils.text("\(page)/\(size)", for: displayLabel)
    }
    
    func listar() {
        if let id = self.documento?.id {
            showActivityIndicator()
            let observable = ImagemService.listar(documentoId: id)
            prepare(for: observable)
                .subscribe(
                    onNext: { imagens in
                        self.imagens = imagens
                        self.atualizar()
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
    
    func onExcluir(imagem: ImagemModel) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: TextUtils.localizedString(forKey: "Label.Imagem"),
                message: TextUtils.localizedString(forKey: "Question.ImagemExcluir"),
                preferredStyle: UIAlertControllerStyle.actionSheet
            )
            alert.addAction(UIAlertAction(
                title: TextUtils.localizedString(forKey: "Label.Sim"),
                style: UIAlertActionStyle.default,
                handler: { action in
                    self.excluir(imagem: imagem)
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
    
    func atualizar() {
        collectionView.reloadData()
        display(position: 0)
    }
    
    func atualizar(model: ImagemModel) {
        imagens.append(model)
        atualizar()
    }
    
    func capturar() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func salvar(image: UIImage) {
        if let documentoId = self.documento?.id {
            showActivityIndicator()
            let observable = ImagemService.salvar(image: image, documentoId: documentoId)
            prepare(for: observable)
                .subscribe(
                    onNext: { model in
                        self.atualizar(model: model)
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
    
    func excluir(imagem: ImagemModel) {
        showActivityIndicator()
        let observable = ImagemService.excluir(imagem: imagem)
        prepare(for: observable)
            .subscribe(
                onNext: { model in
                    if let index = self.imagens.index(where: { $0 === imagem }) {
                        self.imagens.remove(at: index)
                        self.atualizar()
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
    
    @IBAction func onSalvarPressed() {
        if let documentoId = self.documento?.id {
            do {
                try ImagemService.digitalizar(documentoId: documentoId);
                makeToast(message: TextUtils.localizedString(forKey: "Message.SincronizandoDocumento"))
                _ = self.navigationController?.popViewController(animated: true)
            } catch {
                handle(error)
            }
        }
    }
    
    @IBAction func onCapturarButton() {
        capturar()
    }
    
    @IBAction func onJustificarPressed() {
        
    }
}
