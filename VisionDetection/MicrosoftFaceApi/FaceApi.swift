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

//enum FaceAPIResult<T, Error> {
//    case Success(T)
//    case Failure(Error)
//}
//
    class FaceAPI: NSObject {
//
//    // Create person group
//    static func createPersonGroup(personGroupId: String, name: String, userData: String?, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/persongroups/"
//        let urlWithParams = url + personGroupId
//
//        var request = URLRequest(url: URL(string: urlWithParams)!)
//        request.httpMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        var json: [String: AnyObject] = ["name": name as AnyObject]
//
//        if let userData = userData {
//            json["userData"] = userData as AnyObject
//        }
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//            } else {
//                let httpResponse = response as! HTTPURLResponse
//                let statusCode = httpResponse.statusCode
//
//                if (statusCode == 200 || statusCode == 409) {
//                    completion(.Success([] as JSON)) ///!!!!!!
//                } else {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! JSONDictionary
//                        completion(.Failure(NetworkError.ServiceError(json: json)))
//                    }
//                    catch {
//                        completion(.Failure(NetworkError.JSonSerializationError))
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//
//
//    // Create person
//    static func createPerson(personName: String, userData: String?, personGroupId: String, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/persongroups/\(personGroupId)/persons"
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        var json: [String: AnyObject] = ["name": personName as AnyObject]
//        if let userData = userData {
//            json["userData"] = userData as AnyObject
//        }
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//
//            } else {
//
//                let httpResponse = response as! HTTPURLResponse
//                let statusCode = httpResponse.statusCode
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    if statusCode == 200 {
//                        completion(.Success(json as JSON)) /// может быть другой тип
//                    }
//                } catch {
//                    completion(.Failure(NetworkError.JSonSerializationError))
//                }
//            }
//        }
//        task.resume()
//    }
//
//
//
//
//    // Upload face
//    static func uploadFace(faceImage: UIImage, personId: String, personGroupId: String, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/persongroups/\(personGroupId)/persons/\(personId)/persistedFaces"
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "POST"
//        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        let pngRepresentation = UIImagePNGRepresentation(faceImage)
//
//        let task = URLSession.shared.uploadTask(with: request, from: pngRepresentation) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//            }
//            else {
//                let httpResponse = response as! HTTPURLResponse
//                let statusCode = httpResponse.statusCode
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    if statusCode == 200 {
//                        completion(.Success(json as JSON))/// может быть другой тип
//                    }
//                }
//                catch {
//                    completion(.Failure(NetworkError.JSonSerializationError))
//                }
//            }
//        }
//        task.resume()
//    }
//
//
//
//
//    // Post training
//    static func trainPersonGroup(personGroupId: String, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/persongroups/\(personGroupId)/train"
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//
//            } else {
//                let httpResponse = response as! HTTPURLResponse
//                let statusCode = httpResponse.statusCode
//
//                do {
//                    if statusCode == 202 {
//                        completion(.Success([] as JSON))
//                    }
//                    else {
//                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! JSONDictionary
//                        completion(.Failure(NetworkError.ServiceError(json: json)))
//                    }
//                }
//                catch {
//                    completion(.Failure(NetworkError.JSonSerializationError))
//                }
//            }
//        }
//        task.resume()
//    }
//
//
//
//
//
//    // Get training status
//    static func getTrainingStatus(personGroupId: String, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/persongroups/\(personGroupId)/training"
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "GET"
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//            }
//            else {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    completion(.Success(json as JSON))/// может быть другой тип
//                }
//                catch {
//                    completion(.Failure(NetworkError.JSonSerializationError))
//                }
//            }
//        }
//        task.resume()
//    }
//
//

    
    // Detect faces
    static func detectFaces(facesPhoto: UIImage, completion: @escaping ([Face]?, JSONDictionary?, Error?) -> Void) {
        
        let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false"
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let pngRepresentation = UIImageJPEGRepresentation(facesPhoto, 0.2)//UIImagePNGRepresentation(facesPhoto)
        
        let task = URLSession.shared.uploadTask(with: request, from: pngRepresentation) { (data, response, error) in
            
            if let nsError = error {
                completion(nil, nil, nsError)
            
            } else {
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    
                    if statusCode == 200 {

                        var faces = [Face]()
                        if let object = json as? JSONArray {
                            for face in object {
                                guard let faceId = face["faceId"] as? String else { return completion(nil, nil, nil) }
                                if let faceRectangle = face["faceRectangle"] as? [String : Int] {
                                    
                                    guard let height = faceRectangle["height"],
                                        let left = faceRectangle["left"],
                                        let top = faceRectangle["top"],
                                        let width = faceRectangle["width"] else { return completion(nil, nil, nil) }
                                    
                                    let jsFace = Face(faceId: faceId, height: height, width: width, top: top, left: left)
                                    faces.append(jsFace)
                                }
                            }
                            completion(faces, nil, nil)
                        }
                        
                    } else {
                        completion(nil, json as? JSONDictionary, nil)
                    }
                } catch {
                    completion(nil, nil, nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    ///create facelist
    
    static func createFaceList(withName name: String, completion: @escaping (JSONDictionary?) -> Void) {
        
        let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/facelists/\(name)"
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let upload: [String : String] = [
            "name":name,
            "userData":"User-provided data attached to the face list"
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: upload, options: .prettyPrinted)
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                
                print(json)
                
                completion(json as? JSONDictionary)
                
            } catch {
                print("Created")
                completion(nil) // if nil - every things ok
            }
            
        }
        task.resume()
    }
    
        
        
        /// Add faces to faselist
        
        static func addFaceToFaceList(image: UIImage, toFileList: String, completion: @escaping (String?) -> Void) {

            let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/facelists/\(toFileList)/persistedFaces"
            
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            
            request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            
            request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            let pngRepresentation = UIImageJPEGRepresentation(image, 0.2)
            
            let task = URLSession.shared.uploadTask(with: request, from: pngRepresentation) { (data, response, error) in
                
                if let nsError = error {
                    print(nsError)
                    completion(nil)
                } else {
                    
//                    let httpResponse = response as! HTTPURLResponse
//                    let statusCode = httpResponse.statusCode
                    
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? JSONDictionary else { return }
                        
                        if let id = json["persistedFaceId"] as? String {
                            
                            
                           
                            completion(id)
                        
                        } else {
                            print("LAJA")
                        }
   
                    } catch {
                        completion(nil)
                    }
                }
            }

            task.resume()
        }
        
        
        
        
        /// Get list from Facelist
        
        static func getList(_ name: String, completion: @escaping ([String]?, JSONDictionary?, Error?) -> Void) {
            
            let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/facelists/\(name)"
            
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    
                    completion(nil, nil, error)
                    
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    if let object = json as? JSONDictionary {
                        
                        if let persistedFaces = object["persistedFaces"] as? [JSONDictionary] {
                            
                            let array: [String] = persistedFaces.flatMap { (str) in return str["persistedFaceId"] as? String }
                            
                            completion(array, nil, nil)
                        }
                    
                    }
                    
                    
                    completion(nil, json as? JSONDictionary, nil)
                    
                } catch {
                    print("Лажа")
                }
                
            }
            task.resume()
        }
        
        
        
        
        static func findSimilar(faceId: String, faceListId: String, completion: @escaping ([String : Double]?, JSONDictionary?, Error?) -> Void) {
            
            let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/findsimilars"
            
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            
            
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
                    print(error)
                    
                }
                
                
                
                
                if let resp = response {
                    
                    let httpResponse = resp as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    print(statusCode)
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    
                    if let object = json as? JSONArray {
                        var dict = [String:Double]()
                        for i in object {
                            //print((i as! JSONDictionary)["confidence"]!)
                            if let temp = i as? JSONDictionary {
                                guard let key = temp["persistedFaceId"] as? String,
                                    let value = temp["confidence"] as? Double else { return }
                                
                                dict[key] = value
                            }
                        }
                        completion(dict, nil, nil)
                    }
                    
                } catch {
                    print("Лажа")
                }
                
            }
            task.resume()
        }
        
        
        /// Delete face from facelist

        static func delete(face: String, fromFileList: String, completion: @escaping (JSONDictionary?) -> Void) {
            
            let url = "https://northeurope.api.cognitive.microsoft.com/face/v1.0/facelists/\(fromFileList)/persistedFaces/\(face)"
            
            var request = URLRequest(url: URL(string: url)!)
            
            request.httpMethod = "DELETE"
            
            request.addValue("e54dfdcd23a048d18bc3d1910c266cfa", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let nsError = error {
                    print(nsError)
                    completion(nil)
                } else {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? JSONDictionary

                        completion(json)
                        
                    } catch {
                        completion(nil)
                    }
                }
            }
            
            task.resume()
        }
    
//    https://northeurope.api.cognitive.microsoft.com/face/v1.0/
    
    
//    48de3b2fb4514f14a2aaa5129e313f80
//    https://westcentralus.api.cognitive.microsoft.com/face/v1.0
    
    
//    // Identify faces in people group
//    static func identify(faces faceIds: [String], personGroupId: String, completion: @escaping (_ result: FaceAPIResult<JSON, Error>) -> Void) {
//
//        let url = "https://api.projectoxford.ai/face/v1.0/identify"
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
//
//
//        let json: [String: AnyObject] = ["personGroupId": personGroupId,
//                                         "maxNumOfCandidatesReturned": 1,
//                                         "confidenceThreshold": 0.7,
//                                         "faceIds": faceIds
//        ] as [String: AnyObject]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            if let nsError = error {
//                completion(.Failure(NetworkError.UnexpectedError(nsError: nsError as NSError)))
//            }
//            else {
//                let httpResponse = response as! HTTPURLResponse
//                let statusCode = httpResponse.statusCode
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    if statusCode == 200 {
//                        completion(.Success(json as JSON))/// может быть другой тип
//                    }
//                    else {
//                        completion(.Failure(NetworkError.ServiceError(json: json as! JSONDictionary)))
//                    }
//                }
//                catch {
//                    completion(.Failure(NetworkError.JSonSerializationError))
//                }
//            }
//        }
//        task.resume()
//    }
}
