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
        
        let pngRepresentation = UIImageJPEGRepresentation(facesPhoto, 0.9)
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
    

    
    
    
    
    ///Get Positive/Negative
    static func getPositive_Negative(id: String, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        
        let url = ApplicationConstants.mixoftApiUrl + id
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        Alamofire.request(request).responseJSON { (response) in
            completion(response.data, response.response, response.error)
        }
    }
    
    
}
