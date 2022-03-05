//
//  UrlPhotoHandling.swift
//  glimovie
//
//  Created by Affandy Murad on 05/03/22.
//

import UIKit

class UrlPhotoHandling: UIImageView {
    
    let baseBlue = UIColor(red: 0.10, green: 0.22, blue: 0.51, alpha: 1.00)
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String, kata: String) {
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        if verifyUrl(urlString) == false {
            self.setImageForName(kata, backgroundColor: baseBlue, circular: true, textAttributes: nil, gradient: true)
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if imageToCache != nil {
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                } else {
                    self.setImageForName(kata, backgroundColor: self.baseBlue, circular: true, textAttributes: nil, gradient: true)
                    print("Error Loading Image")
                }
            })
        }).resume()
    }
    
    func verifyUrl (_ urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}
