//
//  Extentions.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit


extension Dictionary where Value:Comparable {
    var sortedByValue:[(Key,Value)] {return Array(self).sorted{$0.1 < $1.1}}
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIViewContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}




//extension UIImage {
//    
//    func resize(toTargetSize targetSize: CGSize, rect1: CGRect) -> UIImage {
//        
//        let newScale = self.scale // change this if you want the output image to have a different scale
//        let originalSize = self.size
//        
//        let widthRatio = targetSize.width / originalSize.width
//        let heightRatio = targetSize.height / originalSize.height
//        
//        // Figure out what our orientation is, and use that to form the rectangle
//        let newSize: CGSize
//        if widthRatio > heightRatio {
//            newSize = CGSize(width: floor(originalSize.width * heightRatio), height: floor(originalSize.height * heightRatio))
//        } else {
//            newSize = CGSize(width: floor(originalSize.width * widthRatio), height: floor(originalSize.height * widthRatio))
//        }
//        
//        
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(origin: CGPoint(x: rect1.origin.x, y: rect1.origin.y), size: newSize)
//        
//        // Actually do the resizing to the rect using the ImageContext stuff
//        let format = UIGraphicsImageRendererFormat()
//        format.scale = newScale
//        format.opaque = true
//        let newImage = UIGraphicsImageRenderer(bounds: rect, format: format).image() { _ in
//            self.draw(in: rect)
//        }
//        
//        return newImage
//    }
//}
//
//
//extension UIImage {
//    
//    func cropping(to quality: CGInterpolationQuality, rect: CGRect) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
//        
//        let context = UIGraphicsGetCurrentContext()! as CGContext
//        context.interpolationQuality = quality
//        
//        let drawRect : CGRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.size.width, height: self.size.height)
//        
//        context.clip(to: CGRect(x:0, y:0, width: rect.size.width, height: rect.size.height))
//        
//        self.draw(in: drawRect)
//        
//        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        return croppedImage
//    }
//}

