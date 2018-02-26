//
//  AppConstans.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import Foundation


import Foundation

struct ApplicationConstants {
    
//    // Graph information
//    static let clientId = "ENTER_CLIENT_ID"
//    static let scopes   = ["User.ReadBasic.All",
//                           "offline_access"]
    
    // Cognitive services information
    static let ocpApimSubscriptionKey = "e54dfdcd23a048d18bc3d1910c266cfa"
}

enum NetworkError: Error {
    case UnexpectedError(nsError: NSError?)
    case ServiceError(json: [String: AnyObject])
    case JSonSerializationError
}

typealias JSON = AnyObject
typealias JSONDictionary = [String: JSON]
typealias JSONArray = [JSON]
