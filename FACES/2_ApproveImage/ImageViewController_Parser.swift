//
//  ImageViewController_Parser.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 28.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit


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
    
    
    
    func noAnyFacesAlert() {
        let alert = UIAlertController(title: "Упс...", message: "Не обнаружено лиц, попробуйте еще раз", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: {
            self.progressView.hide()
        })
    }
    
}
