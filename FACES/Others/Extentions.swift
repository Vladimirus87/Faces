//
//  Extentions.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import Vision



//sorting by keys in the dictionary
extension Dictionary where Value:Comparable {
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 < $1.1}}
}



//cropping images
extension UIImage {
    
    func scaleImageWithAspectToWidth(toWidth:CGFloat) -> UIImage? {
        let oldWidth:CGFloat = size.width
        let scaleFactor:CGFloat = toWidth / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}



