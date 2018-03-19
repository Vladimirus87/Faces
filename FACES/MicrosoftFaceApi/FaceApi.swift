//
//  FaceApi.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import UIKit
import Alamofire

class FaceAPI: NSObject {
    

    /// Detect faces
    static func detectFaces(facesPhoto: UIImage, completion: @escaping (Data?, Int?, Error?) -> Void) {
        
        let url = "\(ApplicationConstants.location)/detect?returnFaceId=true&returnFaceLandmarks=false"
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        // need to show count of bite
        let pngRepresentation = UIImageJPEGRepresentation(facesPhoto, 0.9)//UIImagePNGRepresentation(facesPhoto)
       
        print("__________________",pngRepresentation?.sizeString(), "__________________")
        
        
        let task = URLSession.shared.uploadTask(with: request, from: pngRepresentation) { (data, response, error) in
            
            if let error = error {
                completion(nil, nil, error)
                
            }
            
            if let data = data, let resp = (response as? HTTPURLResponse)?.statusCode {
                completion(data, resp, nil)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
//    ///create facelist
//
//    static func createFaceList(withName name: String, completion: @escaping (JSONDictionary?) -> Void) {
//
//        let url = "\(ApplicationConstants.location)/facelists/\(name)"
//
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "PUT"
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        let upload: [String : String] = [
//            "name":name,
//            "userData":"User-provided data attached to the face list"
//        ]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: upload, options: .prettyPrinted)
//        request.httpBody = jsonData
//
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//
//                print(json)
//
//                completion(json as? JSONDictionary)
//
//            } catch {
//                print("Created")
//                completion(nil) // if nil - every things ok
//            }
//
//        }
//        task.resume()
//    }
//
//
//
//
//
//
//
//
//    /// Add faces to faselist
//
//    static func addFaceToFaceList(image: UIImage, toFileList: String, completion: @escaping (String?) -> Void) {
//
//        let url = "\(ApplicationConstants.location)/facelists/\(toFileList)/persistedFaces"
//
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "POST"
//
//        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//
//        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        let pngRepresentation = UIImageJPEGRepresentation(image, 0.2)
//
//        let task = URLSession.shared.uploadTask(with: request, from: pngRepresentation) { (data, response, error) in
//
//            if let nsError = error {
//                print(nsError)
//                completion(nil)
//            } else {
//
//                //                    let httpResponse = response as! HTTPURLResponse
//                //                    let statusCode = httpResponse.statusCode
//
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? JSONDictionary else { return }
//
//                    if let id = json["persistedFaceId"] as? String {
//
//
//
//                        completion(id)
//
//                    } else {
//                        print("LAJA")
//                    }
//
//                } catch {
//                    completion(nil)
//                }
//            }
//        }
//
//        task.resume()
//    }
//
//
//
//
//
//
//
//
//    /// Get list from Facelist
//
//    static func getList(_ name: String, completion: @escaping ([String]?, JSONDictionary?, Error?) -> Void) {
//
//        let url = "\(ApplicationConstants.location)/facelists/\(name)"
//
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "GET"
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let error = error {
//
//                completion(nil, nil, error)
//
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//
//                if let object = json as? JSONDictionary {
//
//                    if let persistedFaces = object["persistedFaces"] as? [JSONDictionary] {
//
//                        let array: [String] = persistedFaces.flatMap { (str) in return str["persistedFaceId"] as? String }
//
//                        completion(array, nil, nil)
//                    }
//
//                }
//
//
//                completion(nil, json as? JSONDictionary, nil)
//
//            } catch {
//                print("Лажа")
//            }
//
//        }
//        task.resume()
//    }
//
    
    
    
    /// Find Similar
    
    static func findSimilar(faceId: String, faceListId: String, completion: @escaping (Data?, Int?, Error?) -> Void) {
        
        let url = "\(ApplicationConstants.location)/findsimilars"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let upload: [String : AnyObject] = [
            "faceId" : faceId,
            "faceListId" : faceListId,
            "maxNumOfCandidatesReturned" : 10,
            "mode" : "matchFace"
            ] as [String : AnyObject]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: upload, options: .prettyPrinted)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(nil, nil, error)
            }
            
            
            if let data = data, let resp = (response as? HTTPURLResponse)?.statusCode {
                completion(data, resp, nil)
            }
        }
        task.resume()
    }
    
    
    
    
//    /// Delete face from facelist
//    
//    static func delete(face: String, fromFileList: String, completion: @escaping (JSONDictionary?) -> Void) {
//        
//        let url = "\(ApplicationConstants.location)/facelists/\(fromFileList)/persistedFaces/\(face)"
//        
//        var request = URLRequest(url: URL(string: url)!)
//        
//        request.httpMethod = "DELETE"
//        
//        request.addValue(ApplicationConstants.subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//        
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if let nsError = error {
//                print(nsError)
//                completion(nil)
//                
//            } else {
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? JSONDictionary
//                    
//                    completion(json)
//                    
//                } catch {
//                    completion(nil)
//                }
//            }
//        }
//        
//        task.resume()
//    }

    
    
    
    
    ///Get Positive/Negative
    static func getPositive_Negative(id: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        
        let url = "http://streams.x.kiev.ua/api_ru.php?id=\(id)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        Alamofire.request(request).responseJSON { (response) in
            completion(response.data, response.response, response.error)
        }
    }
    
    
}
