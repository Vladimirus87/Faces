//
//  ImageViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import Vision


class ImageViewController: UIViewController {

    var image: UIImage? = nil
    var completion: ((UIImage?)->())?
    var faceIdBestResult : String?
    var negative_Positive: [String: [String]]?
    var oneFace = false
    var doneIsActive = false
    

    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var mainImage: UIImageView!{
        didSet {
            mainImage.isUserInteractionEnabled = false
        }
    }
    
    var tappedView : UIView? {
        
        willSet {
            if newValue?.layer.borderColor == UIColor.red.cgColor {
                newValue?.layer.borderColor = UIColor.green.cgColor
            } else {
                newValue?.layer.borderColor = UIColor.red.cgColor
            }
        } didSet {
            if oldValue?.layer.borderColor == UIColor.green.cgColor  {
                oldValue?.layer.borderColor = UIColor.red.cgColor
            } else {
                oldValue?.layer.borderColor = UIColor.green.cgColor 
                if doneIsActive == false {
                    done.isUserInteractionEnabled = true
                    done.alpha = 1
                    doneIsActive = true
                }
            }
        }
    }
    
    
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
    
    
    
    var progress: AJProgressView!{
        didSet{
            progress.tempFrame = CGRect(x: view.frame.size.width / 2 - 50, y: view.frame.size.height / 2 - 50, width: 100, height: 100)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        mainImage.image = image ?? UIImage(named: "smile")
        progress = AJProgressView(frame: view.frame)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.drowSqares()
        }
    }
    
    
    
   
    
    //cutting a face from an image
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
    
    
    
  
    //redrawing squares on faces, after rotating
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

    
    
    
    
    
    @IBAction func detect(_ sender: UIButton) {

        progress.show()
        
        guard let cropped = getImage(from: mainImage, in: tappedView?.frame ?? mainImage.frame).1 else {
            progress.hide()
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
    
    

    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        
        completion?(nil)
        self.dismiss(animated: true, completion: nil)
    }
 
}








