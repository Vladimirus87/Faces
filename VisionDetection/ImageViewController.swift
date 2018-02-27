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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


extension ImageViewController {
   
    
    //scan many faces
    func parseManyFacesDetectSuccess(data: Data?) -> [Face]?  {
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
            
            if let object = json as? JSONArray {
                var faces = [Face]()
                
                for face in object {
                    
                    guard let faceId = face["faceId"] as? String else { return nil }
                    
                    if let faceRectangle = face["faceRectangle"] as? [String : Int]? {
                        
                        guard let height = faceRectangle?["height"],
                            let left = faceRectangle?["left"],
                            let top = faceRectangle?["top"],
                            let width = faceRectangle?["width"] else { return nil }
                        
                        let jsFace = Face(faceId: faceId, height: height, width: width, top: top, left: left)
                        faces.append(jsFace)
                    }
                }
                return faces
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    
    
    //scan one face
    func faceDetectSuccessAndFind(data: Data?)  {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
            
            if let object = json as? JSONArray {
                
                if object.isEmpty == false {
                    
                    guard let faceId = object[0]["faceId"] as? String else { return }
                    
                    FaceAPI.findSimilar(faceId: faceId, faceListId: UserDefaults.standard.string(forKey: "FileListName")!, completion: { (data, response, error) in
                        
                        if error != nil {
                            self.errorAlert()
                        }
                        
                        if let statusCode = response {
                            if statusCode == 200 {
                                self.parseSuccess(data: data)
                            } else {
                                self.parseError(data: data)
                            }
                        }
                    })
                    
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    func parseSuccess(data: Data?) {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
            
            if let object = json as? JSONArray {
                var dict = [String : Double]()
                for i in object {
                    if let temp = i as? JSONDictionary {
                        guard let key = temp["persistedFaceId"] as? String,
                            let value = temp["confidence"] as? Double else { return }
                        dict[key] = value
                    }
                }
                
                
                DispatchQueue.main.async {
                    if let maxSimilar = dict.sortedByValue.last {
                        self.faceIdBestResult = maxSimilar.0
                        self.performSegue(withIdentifier: "toDetection", sender: self)
                        self.progressView.hide()
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    func parseError(data: Data?) {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
            
            if let object = json as? JSONDictionary {
                
                if let dict = object["error"] as? [String : String] {
                    
                    if let key = dict["code"], let value = dict["message"] {
                        let alert = UIAlertController(title: key, message: value, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: {
                            self.progressView.hide()
                        })
                        
                    } else if let key = dict["statusCode"], let value = dict["message"] {
                        let alert = UIAlertController(title: key, message: value, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(ok)
                        self.progressView.hide()
                        self.present(alert, animated: true, completion: {
                            self.progressView.hide()
                        })
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription)
            
        }
        
    }
    
    
    func errorAlert() {
        let alert = UIAlertController(title: "Упс...", message: "Проверьте слединение с интернет и повторите попытку", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: {
            self.progressView.hide()
        })
    }
    
}





