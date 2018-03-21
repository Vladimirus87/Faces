//
//  PreviewView.swift
//  VisionDetection
//
//  Created by Wei Chieh Tseng on 09/06/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

protocol ChangesWithDistanceToHead {
    func changeImage(to: UIImage)
}



class PreviewView: UIView {

    var delegate: ChangesWithDistanceToHead?
    private var maskLayer = [CAShapeLayer]()
    
    
    var facebounds: CGRect? //{
        
//        didSet {
//
//            if let new = facebounds {
//
//                if lastRects.count > 0 {
//                    print("new.origin.x", new.origin.x)
//                    print("lastRects.last!.origin.x", lastRects.last!.origin.x)
//                    if new.origin.x > lastRects.last!.origin.x + 10 || new.origin.x < lastRects.last!.origin.x + 10,
//                        new.origin.y > lastRects.last!.origin.y + 10 || new.origin.y < lastRects.last!.origin.y + 10 {
//
//                        lastRects.append(new)
//                    }
//                }
//            }
//        }
//    }
    
    
    
//    var lastRects = [CGRect]() {
//        didSet {
//
//            print(lastRects.last)
//            
//            if lastRects.count > 10 {
//                lastRects.remove(at: 0)
//            }
//        }
//    }
    
    
    
    // MARK: AV capture properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var sizeOfFace = UIScreen.main.bounds.width - 30
    var permiceForPhoto: CGFloat = 60.0
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    

    
    var imageForButton: UIImage = UIImage(named: "shootWhite")! {
        willSet (newValue) {
            if newValue != imageForButton {
                delegate?.changeImage(to: newValue)
            }
        }
    }
    
    
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
   
    
    // Create a new layer drawing the bounding box
    private func createLayer(in rect: CGRect) -> CAShapeLayer {
        
        let mask = CAShapeLayer()
        mask.frame = rect
        mask.cornerRadius = 10
        mask.opacity = 0.75
        mask.borderColor = UIColor.red.cgColor
        mask.borderWidth = 1.0
        maskLayer.append(mask)
        layer.insertSublayer(mask, at: 1)
        
        return mask
    }
    
    
    
    func drawFaceboundingBox(face : VNFaceObservation) {
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -frame.height)
        let translate = CGAffineTransform.identity.scaledBy(x: frame.width, y: frame.height)
        
        // The coordinates are normalized to the dimensions of the processed image, with the origin at the image's lower-left corner.
        facebounds = face.boundingBox.applying(translate).applying(transform)
        
        _ = createLayer(in: facebounds!)
        
        if ((facebounds?.width)! < sizeOfFace && (facebounds?.width)! > (sizeOfFace - 100)) && (facebounds?.midY)! > ((UIScreen.main.bounds.height / 2) - permiceForPhoto) && (facebounds?.midY)! < ((UIScreen.main.bounds.height / 2) + permiceForPhoto) {
            
            imageForButton = UIImage(named: "shootRed")!
        } else {
            imageForButton = UIImage(named: "shootWhite")!
        }
    }
    
  
 
    func removeMask() {
        for mask in maskLayer {
            mask.removeFromSuperlayer()
        }
        
        maskLayer.removeAll()
        facebounds = nil
    }
}


