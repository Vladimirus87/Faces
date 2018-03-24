//
//  DrawOnBanner.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 28.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

extension ResultViewController {
   
    //Drawing text on a banner with the Faces logo
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 20)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: CGSize(width: image.size.width / 2, height: image.size.height))
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //transformation into text, which will look correct on the banner
    func getString(arr: [String]) -> String {
        
        let str = arr.map { (string) in return  "\n \u{2022}" + " " + string }.joined(separator: "")
        return str
    }
}
