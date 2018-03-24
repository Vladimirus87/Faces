//
//  ChangeButtonColor.swift
//  Faces
//
//  Created by Владимир Моисеев on 24.03.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

extension CameraViewController: ChangesWithDistanceToHead {
    
    func changeImage(toImage: UIImage) {
        shoot.imageView?.image = toImage
    }
    
}

