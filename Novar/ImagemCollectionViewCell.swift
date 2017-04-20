//
//  ImagemCollectionViewCell.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 21/12/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift

protocol ImagemCollectionViewCellDelegate {
    func onExcluir(imagem: ImagemModel)
}

class ImagemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var excluirButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var data: Data?
    var imagem: ImagemModel?
    var delegate: ImagemCollectionViewCellDelegate?
    
    var editavel = false
    let disposableBag = DisposeBag()
    
    func popular(imagem: ImagemModel, editavel: Bool) {
        self.imagem = imagem
        self.editavel = editavel
        activityIndicatorView.stopAnimating()
        carregar()
    }
    
    func carregar() {
        if let nome = imagem?.nome {
            if let path = try? ImagemService.getAbsolutePathForImages(for: nome) {
                if FileManager.default.fileExists(atPath: path) {
                    let url = URL(fileURLWithPath: path)
                    data = try? Data(contentsOf: url)
                }
            }
        }
        if data != nil {
            exibir(data: data!)
        } else if let id = imagem?.id {
            activityIndicatorView.startAnimating()
            let observable = ImagemService.download(id: id)
            observable
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(
                    onNext: { data in
                        self.exibir(data: data)
                    },
                    onError: { error in
                        self.activityIndicatorView.stopAnimating()
                    },
                    onCompleted: {
                        self.activityIndicatorView.stopAnimating()
                    }
                ).addDisposableTo(disposableBag)
        }
    }
    
    func exibir(data: Data) {
        if data.count > 0 {
            self.data = data
            imagemView.image = UIImage(data: data)
        } else {
            imagemView.image = UIImage(named: "noImage")
        }
        excluirButton.isHidden = !editavel
    }
    
    @IBAction func onExcluirPressed() {
        if let imagem = self.imagem, let delegate = self.delegate {
            delegate.onExcluir(imagem: imagem)
        }
    }
}
