//
//  DetailViewController.swift
//  PhotoGallary
//
//  Created by Kirit on 22/10/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgPhoto: UIImageView!
    var strImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavbar()
        //imgPhoto.image = UIImage(named: strImage)
        imgPhoto.setImage1(strUrl: strImage, strDefault: "", cornerRadius: 1, forImageDow: false)
    }

    func setNavbar(){
        // backgroud Color
        self.navigationController?.navigationBar.backgroundColor = .black
        
        let imgBack = UIImage(systemName: "arrow.backward")
        let btnBack = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(onClickBack))
        btnBack.tintColor = .white
        
        
        //adding item to left view
        self.navigationItem.leftBarButtonItems = [btnBack]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    @objc func onClickBack(){
        self.dismiss(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
