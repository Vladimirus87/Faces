//
//  Vision.swift
//  Faces
//
//  Created by Владимир Моисеев on 21.03.18.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import Vision


extension ImageViewController {
    
    
    private func convertImageOrientation(orientation: UIImageOrientation) -> CGImagePropertyOrientation  {
        let cgiOrientations : [ CGImagePropertyOrientation ] = [
            .up, .down, .left, .right, .upMirrored, .downMirrored, .leftMirrored, .rightMirrored
        ]
        
        return cgiOrientations[orientation.rawValue]
    }
    
    
    
    
    public func drowSqares() {
        
        let scaledFrame = self.imageFrameAspectFit(imageView: mainImage)
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            req.results?.forEach ({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let height = scaledFrame.height * faceObservation.boundingBox.height
                    
                    let x = scaledFrame.origin.x + (scaledFrame.width * faceObservation.boundingBox.origin.x)
                    
                    let y = (scaledFrame.height * (1 -  faceObservation.boundingBox.origin.y) - height) + scaledFrame.origin.y
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    
                    let rect = CGRect(x: x, y: y, width: height, height: height)
                    redView.frame = rect
                    
                    self.view.addSubview(redView)
                    
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.saaa(_:)))
                    redView.addGestureRecognizer(gesture)
                    self.rects.append(redView)
                }
            })
        }
        
        guard let orientation = self.mainImage.image?.imageOrientation else { return }
        let convertedOrientation = convertImageOrientation(orientation: orientation)
        guard let cgImage = image?.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: convertedOrientation, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
    
    
    @objc func saaa(_ tap: UITapGestureRecognizer) {
        
        tappedView = tap.view!
    }
    
}
