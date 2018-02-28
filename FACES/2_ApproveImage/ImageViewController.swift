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

extension Data {
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        
        return bcf.string(fromByteCount: Int64(count))
    }}


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
    var faceIdBestResult : String?
    var progressView: AJProgressView!
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        mainImage.image = image ?? UIImage(named: "smile")
        progressView = AJProgressView()
    }
    
    
  
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let img = mainImage.image?.resizeImage(300, opaque: true, contentMode: .scaleAspectFit)
        
        img?.face.crop { result in
            switch result {
            case .success(let faces): self.imagesFromFaces = faces.map { $0 }
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

    
    
    
    
    
    @IBAction func Detect(_ sender: UIButton) {
        
        progressView.show()
        
        FaceAPI.detectFaces(facesPhoto: mainImage.image!) { (data, response, error)  in
            
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
    func testForApiAndData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let result = try contex.fetch(request)
            for i in result as! [Person] {
                print(" Core Data - \(i.id ?? "nothing")")
            }
        } catch {
            print("Failed")
        }
        
        FaceAPI.getList(UserDefaults.standard.string(forKey: "FileListName")!) { (a, _, _) in
            if let ss = a {
                for i in ss {
                    
                    print("Microsoft - \(i)")
                }
            }
        }
    }
}








