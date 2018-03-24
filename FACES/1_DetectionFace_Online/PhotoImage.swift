//
//  PhotoImage.swift
//  Faces
//
//  Created by Владимир Моисеев on 24.03.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

extension CameraViewController {
    
    //flipping
    func imageRotatedByDegrees(im: UIImage, degrees: CGFloat) -> UIImage {
        
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: im.size.width, height: im.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(im.cgImage!, in: CGRect(x: -im.size.width / 2, y: -im.size.height / 2, width: im.size.width, height: im.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    
    //correction of images based on the screen orientation
    func fixedOrientation(im: UIImage) -> UIImage {
        if im.imageOrientation == UIImageOrientation.up {
            return im
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch im.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: im.size.width, y: im.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: im.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: im.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch im.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: im.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: im.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(im.size.width),
                                       height: Int(im.size.height),
                                       bitsPerComponent: im.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: im.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch im.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(im.cgImage!, in: CGRect(x: 0, y: 0, width: im.size.height, height: im.size.width))
        default:
            ctx.draw(im.cgImage!, in: CGRect(x: 0, y: 0, width: im.size.width, height: im.size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}
