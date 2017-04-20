//
//  TermoUsoViewController.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 20/10/16.
//  Copyright © 2016 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class TermoUsoViewController: NovarViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var switchField: UISwitch!
    @IBOutlet weak var aceitarButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        switchField.isEnabled = false
        aceitarButton.isEnabled = false
        let url = URL(string: Config.termoUsoURL)!
        let request = URLRequest(url: url)
        webView.delegate = self
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        switchField.isEnabled = false
        aceitarButton.isEnabled = false
        indicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        switchField.isEnabled = true
        indicatorView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        indicatorView.stopAnimating()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSwitchChange(_ sender: AnyObject) {
        aceitarButton.isEnabled = switchField.isOn
    }
    
    @IBAction func onAceitarPressed() {
        let observable = LoginService.aceitar()
        showActivityIndicator()
        prepare(for: observable).subscribe(
            onNext: {
                self.hideActivityIndicator()
                if let usuario = self.usuario {
                    usuario.termoAceite = true
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                    self.navigationController?.pushViewController(controller!, animated: true)
                }
            },
            onError: { error in
                self.hideActivityIndicator()
                self.handle(error)
            }
        ).addDisposableTo(disposableBag)
    }
}
