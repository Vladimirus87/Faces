//
//  ImageVC_Alert.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 15.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

extension ImageViewController {
    
    func alert(title: String?, message: String?, buttonTitle: String = "Close") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
