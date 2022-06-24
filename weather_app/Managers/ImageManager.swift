//
//  ImageManager.swift
//  weather_app
//
//  Created by admin on 6/22/22.
//

import Foundation

import UIKit

class ImageManager {
    
    static let instance = ImageManager()
    
    func readStringUrl(urlStr: String) -> UIImage? {
        let url = URL(string: urlStr)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        return image
    }
    
    func readUrl(urlStr: URL) -> UIImage? {
        let data = try? Data(contentsOf: urlStr)
        let image = UIImage(data: data!)
        
        return image
    }
    
    
}
