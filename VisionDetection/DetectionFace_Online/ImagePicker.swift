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
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        self.image = chosenImage
        print(chosenImage.size)
        
        dismiss(animated:true, completion: {
            
            self.performSegue(withIdentifier: "toImageVC", sender: self)
        })
    }
    
}
