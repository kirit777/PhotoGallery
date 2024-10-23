//
//  PhotosCollectionViewCell.swift
//  PhotoGallary
//
//  Created by Kirit on 22/10/24.
//

import UIKit

//protocol PhotosCollectionViewCellDelegate {
//    func onClickPhoto(){
//        
//    }
//}

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setCellData(obj:NSDictionary){
        if let dictUrls = obj.value(forKey: "urls") as? NSDictionary {
            if let strImage = dictUrls.value(forKey: "thumb") as? String{
                imgPhoto.setImage1(strUrl: strImage, strDefault: "", cornerRadius: 1, forImageDow: false)
            }
        }
        //imgPhoto.setImage1(strUrl: "https://d2xkd1fof6iiv9.cloudfront.net/images/courses/\(strId)/169_820.jpg", strDefault: "", cornerRadius: 1, forImageDow: false)
        
    }

}
