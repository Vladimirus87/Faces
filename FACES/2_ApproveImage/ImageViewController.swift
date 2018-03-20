//
//  ImageViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
//import FaceCropper
import CoreData
import Vision





class ImageViewController: UIViewController {

    var image: UIImage? = nil
    
    var tappedView : UIView? {
        
        willSet {
            if newValue?.backgroundColor == .red {
                newValue?.backgroundColor = .green
            } else {
                newValue?.backgroundColor = .red
            }
        } didSet {
            if oldValue?.backgroundColor == .green {
                oldValue?.backgroundColor = .red
            } else {
                oldValue?.backgroundColor = .green
                if doneIsActive == false {
                    done.isUserInteractionEnabled = true
                    done.alpha = 1
                    doneIsActive = true
                }
            }
        }
    }
    
    
    var completion: ((UIImage?)->())?
    var faceIdBestResult : String?
    var negative_Positive: [String: [String]]?
    var progressView: AJProgressView!
    var oneFace = false
    var doneIsActive = false
    
    var rects = [UIView]() {
        didSet {
            if rects.count == 1 {
                tappedView = rects.first
                oneFace = true
            } else {
                tappedView = nil
            
                if doneIsActive == true {
                    done.isUserInteractionEnabled = false
                    done.alpha = 0.5
                    doneIsActive = false
                }
                oneFace = false
                
            }
        }
    }
    
    

    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var mainImage: UIImageView!{
        didSet {
            mainImage.isUserInteractionEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        mainImage.image = image ?? UIImage(named: "smile")
        progressView = AJProgressView()
        
//        drowSqares(nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            self.drowSqares()
    }
    
    
    
    
    
    

    func convertImageOrientation(orientation: UIImageOrientation) -> CGImagePropertyOrientation  {
        let cgiOrientations : [ CGImagePropertyOrientation ] = [
            .up, .down, .left, .right, .upMirrored, .downMirrored, .leftMirrored, .rightMirrored
        ]

        return cgiOrientations[orientation.rawValue]
    }
    
    
    
    func drowSqares() {

        let scaledFrame = self.imageFrameAspectFit(imageView: mainImage)
        print(scaledFrame)

        let request = VNDetectFaceRectanglesRequest { (req, err) in

            if let err = err {
                print("Failed to detect faces:", err)
                return
            }

            req.results?.forEach ({ (res) in
                print("(((((((( + )))))))")

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

                    print("bbb", faceObservation.boundingBox)
                }
            })
        }

        
        guard let orientation = self.mainImage.image?.imageOrientation else {return}
        let convertedOrientation = convertImageOrientation(orientation: orientation)
        guard let cgImage = image?.cgImage else { return }

        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: convertedOrientation, options: [:])//(cgImage: cgImage, options: [:])
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
    
    
    
    func getImage(from contextView: UIView, in cropFrame: CGRect) -> (UIImage?, CGImage?) {
        
        UIGraphicsBeginImageContext(CGSize(width: contextView.frame.size.width,
                                           height: contextView.frame.size.height))
        contextView.drawHierarchy(in: CGRect(x: contextView.frame.origin.x,
                                             y: contextView.frame.origin.y,
                                             width: contextView.frame.size.width,
                                             height: contextView.frame.size.height),
                                  afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return (nil, nil)}
        UIGraphicsEndImageContext()
        
        guard let croppedImage = image.cgImage?.cropping(to: cropFrame) else {return (image, nil)}
        
        return (image, croppedImage)
    }
    
    
    /// Возвращает ревльный размер картинки
    func imageSizeAspectFit(imgview: UIImageView) -> CGSize {
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
    
    
    ///Возвращает ревльный фрейм картинки
    func imageFrameAspectFit(imageView: UIImageView) -> CGRect {
        
        let size = imageSizeAspectFit(imgview: imageView)
        let point = CGPoint(x: (UIScreen.main.bounds.width - size.width) / 2, y: (UIScreen.main.bounds.height - size.height) / 2)
        
        return CGRect(origin: point, size: size)
    }
    
    
  
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
        
        for subview in view.subviews {
            for squareRect in rects {
                if squareRect.frame == subview.frame {
                    subview.removeFromSuperview()
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.rects = []
            self.tappedView = nil
            self.drowSqares()
            
            print("************\(self.imageSizeAspectFit(imgview: self.mainImage))************")
            
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetection",
            let destVC = segue.destination as? CheckViewController {
            destVC.faceId = faceIdBestResult
            destVC.imageSent = mainImage.image
            destVC.negative_Positive = self.negative_Positive
            destVC.oneFace = oneFace
        }
    }

    
    
    
    
    
    @IBAction func Detect(_ sender: UIButton) {
        
        progressView.show()
        
        guard let cropped = getImage(from: mainImage, in: tappedView?.frame ?? mainImage.frame).1 else {
            progressView.hide()
            return
        }
        
        
        
        FaceAPI.detectFaces(facesPhoto: UIImage(cgImage: cropped)) { (data, response, error)  in
            
            if error != nil {
                self.errorAlert()
            }
            
            if let statusCode = response {
                if statusCode != 200 {
                    self.parseError(data: data)
                } else if data?.count == 2 {
                    self.noAnyFacesAlert()
                } else {
                    self.faceDetectSuccessAndFind(data: data) 
                }
            }
        }
    }
    
    

    
    
    @IBAction func CancelPressed(_ sender: UIButton) {
        
        completion?(nil)
        self.dismiss(animated: true, completion: nil)
    }
    

    
}








