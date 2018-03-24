//
//  ImageSizeAspectFit.swift
//  Faces
//
//  Created by Владимир Моисеев on 21.03.18.
//  Copyright © 2018 Willjay. All rights reserved.

/// Methods for obtaining real image size if contentMode == .aspectFit

import UIKit

extension ImageViewController {
    
    private func imageSizeAspectFit(imgview: UIImageView) -> CGSize {
        var newwidth: CGFloat
        var newheight: CGFloat
        let image: UIImage = imgview.image!
        
        if image.size.height >= image.size.width {
            newheight = imgview.frame.size.height;
            newwidth = (image.size.width / image.size.height) * newheight
            
            if newwidth > imgview.frame.size.width {
                let diff: CGFloat = imgview.frame.size.width - newwidth
                newheight = newheight + diff / newheight * newheight
                newwidth = imgview.frame.size.width
            }
            
        } else {
            
            newwidth = imgview.frame.size.width
            newheight = (image.size.height / image.size.width) * newwidth
            
            if newheight > imgview.frame.size.height {
                let diff: CGFloat = imgview.frame.size.height - newheight
                newwidth = newwidth + diff / newwidth * newwidth
                newheight = imgview.frame.size.height
            }
        }
        
        return CGSize(width: newwidth, height: newheight)
    }
    
    
    
    func imageFrameAspectFit(imageView: UIImageView) -> CGRect {

        let size = imageSizeAspectFit(imgview: imageView)
        let point = CGPoint(x: (UIScreen.main.bounds.width - size.width) / 2, y: (UIScreen.main.bounds.height - size.height) / 2)
        
        return CGRect(origin: point, size: size)
    }
}
