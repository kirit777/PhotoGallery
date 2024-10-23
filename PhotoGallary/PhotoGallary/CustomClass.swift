//
//  CustomClass.swift
//  PhotoGallary
//
//  Created by Kirit on 22/10/24.
//

import Foundation
import UIKit
import Kingfisher


func getNavigationTitle(title:String,font:UIFont,xPosition : CGFloat? = 0) -> UILabel {
    let widht = UIScreen.main.bounds.size.width
    let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: widht - (120 + (xPosition ?? 0)), height: 35))
    lblTitle.text = title
    lblTitle.font = font
    lblTitle.textColor = UIColor.white
    lblTitle.textAlignment = .center
    return lblTitle;
}

extension UIView {
    
    func roundCorner(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
extension UIImageView {
    
    func setImage1(strUrl :String , strDefault :String , cornerRadius:CGFloat , forImageDow:Bool) {
        var placeImg :UIImage? = nil
        if strDefault.count > 0 {
            placeImg = UIImage(named: strDefault)!
        }
        let url = URL(string: strUrl)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeImg /*UIImage(named: strDefault)*/,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):

                if forImageDow {
                    _ = saveImageToDocumentDirectory(chosenImage: value.image)
                }
            case .failure( _):

                if strDefault.count > 0 {
                    self.image = UIImage(named: strDefault)
                }
            }
        }
    }
}

func saveImageToDocumentDirectory(chosenImage: UIImage) -> URL {
    
    let filename = "test.jpg"
    let filepath = getFilePath().appendingPathComponent(filename)
    do {
        try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: filepath, options: .atomic)
        return filepath
        
    } catch {
        //printLog(data: error)
        //printLog(data: "file cant not be save at path \(filepath), with error : \(error)");
        return filepath
    }
}

func getFilePath() -> URL {
    let fileManager = FileManager.default
    let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    return  tDocumentDirectory!
}

