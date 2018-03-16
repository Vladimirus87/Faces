//
//  ImageViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import FaceCropper
import CoreData
import Vision





class ImageViewController: UIViewController {

    var image: UIImage? = nil
    lazy var croppedImage = UIImage() // {
//        didSet {
//            if croppedImage != nil {
//
//            }
//        }
//    }
    var tappedView : UIView? {
        
        willSet {
            if newValue?.backgroundColor == .red {
                newValue?.backgroundColor = .green
            } else {
                newValue?.backgroundColor = .red
            }
        }
        didSet {
            if oldValue?.backgroundColor == .green {
                oldValue?.backgroundColor = .red
            } else {
                oldValue?.backgroundColor = .green
            }
        }
    }
    
    
    var completion: ((UIImage?)->())?
    var imagesFromFaces: [UIImage]?
    var faceIdBestResult : String?
    var negative_Positive: [String: [String]]?
    var progressView: AJProgressView!
    var oneFace = false
    
    var rects = [UIView]() {
        didSet {
            if rects.count == 1 {
                tappedView = rects.first
                oneFace = true
            } else {
                tappedView = nil
                oneFace = false
            }
        }
    }
    
    
    
    
    @IBOutlet weak var mainImage: UIImageView!{
        didSet {
            mainImage.isUserInteractionEnabled = false
        }
    }
    
    
    
    
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        mainImage.image = image ?? UIImage(named: "smile")
        progressView = AJProgressView()
        
        drowSqares(nil)
    }
    
    
    
    func drowSqares(_ size: CGSize?) {
        
        var scaledHeight: CGFloat?
        
        if let cc = size {
            scaledHeight = view.frame.width / cc.width * cc.height
        } else {
            scaledHeight = view.frame.width / (image?.size.width)! * (image?.size.height)!
        }
//        let scaledHeight: CGFloat = view.frame.width / (image?.size.width)! * (image?.size.height)!
        
        
        print(scaledHeight, "<<<<<<<<<<<<<<")
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let widthOfImage = self.imageSizeAspectFit(imgview: self.mainImage).width / 2
                    let withOfDisplay = UIScreen.main.bounds.width / 2
                    let dist = withOfDisplay - widthOfImage
                    let height = scaledHeight! * faceObservation.boundingBox.height
                    
                    let x = dist + (self.imageSizeAspectFit(imgview: self.mainImage).width * faceObservation.boundingBox.origin.x)
                    
                    print("xxxxxxxx\(x)xxxxxxxx")
                    
                    print("00000000\(faceObservation.boundingBox.origin.x)")
                    
                    
                    let y = scaledHeight! * (1 -  faceObservation.boundingBox.origin.y) - height
                    let width = height //self.view.frame.width * faceObservation.boundingBox.width
                    
                    print("|||||||| \(self.view.frame.width) ||||||||")
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    
                    let rect = CGRect(x: x, y: y, width: width, height: height)
                    redView.frame = rect
                    
                    self.view.addSubview(redView)
                    
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.saaa(_:)))
                    redView.addGestureRecognizer(gesture)
                    
                    self.rects.append(redView)//faceObservation.boundingBox)
                    
                    print("bbb", faceObservation.boundingBox)
                }
            })
        }
        
        
        
        guard let cgImage = image?.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
    
    
    @objc func saaa(_ tap: UITapGestureRecognizer) {
        
        //print("saaa", tap.view?.frame)
        
        //tap.view?.backgroundColor = tap.view?.backgroundColor == .red ? .green : .red
        
        tappedView = tap.view!
        
//        if tap.view?.backgroundColor == .green {
//            print("green")
//        } else {
//            print("red")
//        }
        
        //croppedImage(image: self.image!, rect: (tap.view?.frame)!)
        
        //        self.rects.forEach { (rect) in
        //                    print(rect)
        ////                    if rect == tap.view?.frame {
        ////                        tap.view?.backgroundColor = .green
        ////                        print("kk")
        ////                    }
        //                }
        
        
        
        
//        if let aaaa = getImage(from: mainImage, in: (tap.view?.frame)!).1 {
//
//            croppedImage = UIImage(cgImage: aaaa)
//        }
        
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
        }
        else {
            newwidth = imgview.frame.size.width
            newheight = (image.size.height / image.size.width) * newwidth
            if newheight > imgview.frame.size.height {
                let diff: CGFloat = imgview.frame.size.height - newheight
                newwidth = newwidth + diff / newwidth * newwidth
                newheight = imgview.frame.size.height
            }
        }
        
        //print(newwidth, newheight)
        //adapt UIImageView size to image size
        return CGSize(width: newwidth, height: newheight)
    }
    
  
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
        for subview in view.subviews {
            for rect in rects {
                if rect.frame == subview.frame {
                    subview.removeFromSuperview()
                    print("was deleted !!!")
                }
            }
        }

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.rects = []
            self.tappedView = nil
            self.drowSqares(size)
            print("was created !!!")
            print("$$$$$\(self.imageSizeAspectFit(imgview: self.mainImage))$$$$$")
        }
    }
    

    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let img = mainImage.image?.resizeImage(300, opaque: true, contentMode: .scaleAspectFit)
//
//        img?.face.crop { result in
//
//
//            switch result {
//            case .success(let faces): self.imagesFromFaces = faces.map { $0 }
//            case .notFound: print("Не вышло")
//            case .failure(let error): print(error.localizedDescription)
//            }
//        }
//    }
    
    
    
    
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

        
        
        
        
//        FaceAPI.createFaceList(withName: "mixoft_1") { (a) in
//            print(a)
//        }
        
        
        
//        FaceAPI.addFaceToFaceList(image: mainImage.image!, toFileList: "moisey_1") { (a) in
//            print(a)
//        }
        
        
//
//        FaceAPI.getList("moisey_1") { (a, _, c) in
//            print(a, c)
//        }
        
        
        
//        FaceAPI.getList("moisey_1") { (a, _, c) in
//            print(a ?? [], c ?? "Unknown")
//
//            guard let facesArr = (a) else { return }
//
//            for faceid in facesArr {
//                print(" _______\(faceid)_______")
//                FaceAPI.delete(face: faceid, fromFileList: "moisey_1", completion: { (delete) in
//                    print(delete ?? "Unknown")
//                })
//            }
//        }
    }
    
    

    
    
    @IBAction func CancelPressed(_ sender: UIButton) {
        
        completion?(nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    /// in future will delete
//    func testForApiAndData() {
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let contex = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//        
//        do {
//            let result = try contex.fetch(request)
//            for i in result as! [Person] {
//                print(" Core Data - \(i.id ?? "nothing")")
//            }
//        } catch {
//            print("Failed")
//        }
//        
//        FaceAPI.getList(UserDefaults.standard.string(forKey: "FileListName")!) { (a, _, _) in
//            if let ss = a {
//                for i in ss {
//                    
//                    print("Microsoft - \(i)")
//                }
//            }
//        }
//    }
    
}








