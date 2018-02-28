//
//  PersonModel.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 22.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

class PersonModel {
    
    var image : UIImage
    var positive: [String]
    var negative: [String]
    
    init(image : UIImage, positive: [String], negative: [String]) {
        self.image = image
        self.positive = positive
        self.negative = negative
    }
}
