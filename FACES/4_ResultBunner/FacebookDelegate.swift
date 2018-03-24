//
//  FacebookDelegate.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 28.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import FBSDKShareKit


extension ResultViewController : FBSDKSharingDelegate {
    
    // if fasebook is not installed
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        
        let alert = UIAlertController(title: nil, message: "fasebook not installed", preferredStyle: .alert)
        let install = UIAlertAction(title: "Установить", style: .default) { _ in
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/facebook/id284882215?mt=8")!)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(install)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {}
    func sharerDidCancel(_ sharer: FBSDKSharing!) {}
}
