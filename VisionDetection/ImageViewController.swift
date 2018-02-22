//
//  ImageViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import Vision
import FaceCropper
import CoreData


struct Face {
    let faceId: String
    let height: Int
    let width: Int
    let top: Int
    let left: Int
}

class ImageViewController: UIViewController {

    var image: UIImage? = nil
    var completion: ((UIImage?)->())?
    var imagesFromFaces: [UIImage]?
    var choosedImage: UIImage?
    
    var testImg = [Face]()
    
    var faceIdBestResult : String?
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var animation: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animation.isHidden = true
        
        if let myImage = image {
            mainImage.image = myImage
        } else {
            mainImage.image = UIImage(named: "smile")
        }
        
//        let person1 = Person()
//        person1.id = "9ff1b77f-5b0f-44ec-a459-6e1f41868f4e"
//        person1.positive = ["доброта", "ум"]
//        person1.negative = ["рассеяность"]
//        


        
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let contex = appDelegate.persistentContainer.viewContext
//
//        do {
//            try contex.save()
//        } catch {
//            print("error")
//        }
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")

        //request.returnsObjectsAsFaults = false

        do {
            let result = try contex.fetch(request)
            for i in result as! [Person] {
                //print(data.value(forKey: "username") as! String)
                print(" Core Data - \(i.id ?? "nothing")")
            }

        } catch {

            print("Failed")
        }
        
        
        FaceAPI.getList("mixoft") { (a, _, _) in
            if let ss = a {
                for i in ss {
                    
                    print("Microsoft - \(i)")
                }
            }
        }
        
//
        
    }
    
    
  
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let img = mainImage.image?.resizeImage(300, opaque: true, contentMode: .scaleAspectFit)

        img?.face.crop { result in
            switch result {
            case .success(let faces):
            self.imagesFromFaces = faces.map { $0 }
            print("images count - \(String(describing: self.imagesFromFaces?.count))")
            
            case .notFound: print("Не вышло")
            case .failure(let error): print(error.localizedDescription)
            }
        }

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetection",
            let destVC = segue.destination as? CheckViewController {
            destVC.faceId = faceIdBestResult
            destVC.imageSent = mainImage.image
        }
    }
    
    
    
    
    
    func animation(willStart: Bool) {
        
        if willStart {
            self.animation.isHidden = false
            self.animation.startAnimating()
        } else {
            self.animation.isHidden = true
            self.animation.stopAnimating()
        }
    }
    

    
    
    @IBAction func Detect(_ sender: UIButton) {
        animation(willStart: true)
        
        FaceAPI.detectFaces(facesPhoto: mainImage.image!) { (a, _, _)  in
            if let faceId = a?[0].faceId {

                FaceAPI.findSimilar(faceId: faceId, faceListId: "mixoft", completion: { (a,_,_) in
                    print(a ?? "Nothing here :(")
                    
                    DispatchQueue.main.async {
                        if let fff = a?.sortedByValue.last {
                            self.faceIdBestResult = fff.0
                            
                            print(">>>>>>>>\(fff.0)")
                            print("\(self.faceIdBestResult)<<<<<<<<<")

                            //! нужно разабраться с памятью или сделать instantiate
                            self.performSegue(withIdentifier: "toDetection", sender: self)
                            self.animation(willStart: false)

                        }
                    }
                })
            }
        }

        
        
        
        
//        FaceAPI.createFaceList(withName: "moisey_1") { (a, b, c) in
//            print(a, b, c)
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
}

