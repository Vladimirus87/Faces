//
//  NS.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    public func sendRequest(_ data: Data, completion: @escaping ([String: Any]?, HTTPURLResponse?, Error?) -> Void) {
        
        guard let url = URL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/") else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(ApplicationConstants.ocpApimSubscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpMethod = "POST"
        
        print("before")
        
        guard let httpBody = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return }
        
        print("after")
        
        request.httpBody = (httpBody as? Data)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let resp = response as? HTTPURLResponse
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, resp, error)
                    return
            }
            
            
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            
            completion(responseObject, resp, nil)
        }
        task.resume()
    }
    
    
    private func saveJsonToken(json: [String: Any]) {
        if let data = json["data"] as? [String: Any] {
            if let token = data["access_token"] as? String {
                UserDefaults.standard.setValue(token, forKey: "user_auth_token")
            }
        }
    }
    
    
    private func saveRegistrationTokenToken(json: [String: Any]) {
        if let data = json["data"] as? [String: Any] {
            if let token = data["access_token"] as? String {
                UserDefaults.standard.setValue(token, forKey: "user_registr_token")
            }
        }
    }
    
}
