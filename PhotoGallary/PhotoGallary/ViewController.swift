//
//  ViewController.swift
//  PhotoGallary
//
//  Created by Kirit on 22/10/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUseName: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }

    func setButton(){
        btnLogin.layer.cornerRadius = 10
        btnLogin.layer.shadowColor = UIColor.black.cgColor
        btnLogin.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnLogin.layer.shadowOpacity = 0.3
        btnLogin.layer.shadowRadius = 5
    }

    @IBAction func onClickLogin(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 5,
                       options: .allowUserInteraction, animations: {
            self.btnLogin.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.btnLogin.backgroundColor = UIColor(red: (175/255), green: (211/255), blue: (226/255), alpha: 1.0)
        }){_ in
            UIView.animate(withDuration: 0.2, animations: {
                self.btnLogin.transform = CGAffineTransform.identity
                self.btnLogin.backgroundColor = UIColor(red: (165/255), green: (201/255), blue: (216/255), alpha: 1.0)
                
                
                if self.txtUseName.text == ""{
                    self.showAlert(msg: "Please enter name")
                    return
                }
                
                if self.txtEmail.text == ""{
                    self.showAlert(msg: "Please enter email")
                    return
                }
                
                let newVc = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
                newVc.modalPresentationStyle = .fullScreen
                if let strName = self.txtUseName.text{
                    newVc.strUser = strName
                }
                let nav = UINavigationController(rootViewController: newVc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            })}
    }
    
    func showAlert(msg:String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "ok", style: .default, handler: {_ in 
            alert.dismiss(animated: true)
        })
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
}

