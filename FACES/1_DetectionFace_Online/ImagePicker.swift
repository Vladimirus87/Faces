//
//  ImagePicker.swift
//  VisionDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}

        self.image = chosenImage
        self.isGalleryImage = true
                
        dismiss(animated:true, completion: {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.performSegue(withIdentifier: "toImageVC", sender: self)
            })
            
        })
    }
    
}
