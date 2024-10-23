//
//  GalleryViewController.swift
//  PhotoGallary
//
//  Created by Kirit on 22/10/24.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    var refreshControl : UIRefreshControl!
    var arrData : NSMutableArray!
    var strUser:String = ""
    
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var conHeightErrorView: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavbar()
        arrData = NSMutableArray()
        fetchDataFromAPI()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        cvPhotos.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchDataFromAPI), for: .valueChanged)
        cvPhotos.dataSource = self
        cvPhotos.delegate = self
        
        cvPhotos.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        cvPhotos.showsVerticalScrollIndicator = false
      
    }
    
    func setNavbar(){
        // backgroud Color
        conHeightErrorView.constant = 0.0
        self.navigationController?.navigationBar.backgroundColor =  UIColor(red: (175/255), green: (211/255), blue: (226/255), alpha: 1.0)
        
        let imgBack = UIImage(systemName: "arrow.backward")
        let btnBack = UIBarButtonItem(image: imgBack, style: .plain, target: self, action: #selector(onClickBack))
        btnBack.tintColor = UIColor(red: (81/255), green: (128/255), blue: (152/255), alpha: 1.0)
        
        
        // Center View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        if strUser.count > 0 {
            titleLbl.text = String("Hi!, \(strUser)")
        }else{
            titleLbl.text = String("Hi!, Guest")
        }
        titleLbl.textColor = UIColor(red: (81/255), green: (128/255), blue: (152/255), alpha: 1.0)
        titleLbl.textAlignment = .center
        titleView.addSubview(titleLbl)
        self.navigationItem.titleView = titleView
        
        //adding item to left view
        self.navigationItem.leftBarButtonItems = [btnBack]
    }
    
    func showHideErrorView(msg:String,hide:Bool){
        if hide{
            conHeightErrorView.constant = 0
            lblErrorMsg.text = ""
        }else{
            conHeightErrorView.constant = 150
            lblErrorMsg.text = msg
        }
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    
    @objc func fetchDataFromAPI() {
        var strQuery = ""
        if let strText = txtSearch.text{
            strQuery = strText
        }else{
            strQuery = ""
        }
        
        self.arrData.removeAllObjects()
        let accessKey = "yEKsIVAb_aqBvBzb892RauT6BqenjjeIg4QrGxfsd14"
        var urlString = ""
        if strQuery.isEmpty{
            urlString = "https://api.unsplash.com/photos/random?client_id=\(accessKey)&count=20"
        }else{
            urlString = "https://api.unsplash.com/search/photos?query=\(strQuery)&client_id=\(accessKey)&per_page=20"
        }
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            DispatchQueue.main.async {
                self.showHideErrorView(msg: "Invalid URL", hide: false)
            }
            return
        }
        
       
        let session = URLSession.shared
        
       
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showHideErrorView(msg: error.localizedDescription, hide: false)
                }
               
                return
            }
            
          
            guard let responseData = data else {
                print("No data received from API")
                DispatchQueue.main.async {
                    self.showHideErrorView(msg: "No data found", hide: false)
                }
                
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
               
                
                DispatchQueue.main.async {
                    
                    self.showHideErrorView(msg: "", hide: true)
                    if self.txtSearch.text!.isEmpty{
                        self.arrData.addObjects(from: json as! [Any])
                    }else{
                        let results = json as? NSDictionary
                        let arr = results!.value(forKey: "results") as! [Any]
                        self.arrData.addObjects(from: arr)
                    }
                    
                    self.cvPhotos.reloadData()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showHideErrorView(msg: error.localizedDescription, hide: false)
                }
                
                print("Failed to decode JSON: \(error)")
            }
        }
        
        
        task.resume()
    }
    

    @objc func onClickBack(){
        self.dismiss(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        fetchDataFromAPI()
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

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        if arrData.count >  0{
            if let obj = arrData[indexPath.row] as? NSDictionary{
                cell.setCellData(obj: obj)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let obj = self.arrData.object(at:indexPath.row) as? NSDictionary {
            if let dictUrls = obj.value(forKey: "urls") as? NSDictionary {
                if let strImage = dictUrls.value(forKey: "full") as? String{
                    let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
                    detailVC.strImage = strImage
                    detailVC.modalPresentationStyle = .fullScreen
                    let nav = UINavigationController(rootViewController: detailVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.navigationController!.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth - 50) / 3 , height: 110)
        
    }
}

