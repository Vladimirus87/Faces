//
//  AppConstans.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//


import Foundation

struct ApplicationConstants {
    
    static let location = "https://northeurope.api.cognitive.microsoft.com/face/v1.0"
    static let subscriptionKey = "e54dfdcd23a048d18bc3d1910c266cfa"
    static let mixoftApiUrl = NSLocalizedString("mixoftApiUrl", comment: "")
}

enum NetworkError: Error {
    case UnexpectedError(nsError: NSError?)
    case ServiceError(json: [String: AnyObject])
    case JSonSerializationError
}

typealias JSON = AnyObject
typealias JSONDictionary = [String: JSON]
typealias JSONArray = [JSON]
