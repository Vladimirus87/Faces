//
//  CheckViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 19.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import CoreData

class CheckViewController: UIViewController {

    
    var faceId: String?
    var imageSent : UIImage?
    var data = [Person]()
    
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myImage = imageSent {
            image.image = myImage
        } else {
            image.image = UIImage(named: "smile")
        }
        
        
        print("\(faceId)--------------")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = NSPredicate(format: "id == %@", faceId ?? "")
        
        do {
            let result = try contex.fetch(request)
            
            for data in result as! [Person] {
                print("+\(data.id)")
                self.data.append(data)
            }
            
        } catch {
            
            print("Failed")
        }
        
        print("-----------\(data.first?.id)")
    }
    
    

    @IBAction func positiveFeatures(_ sender: UIButton) {
        goToResultVC(withPositive: true)
    }

    
    
    
    @IBAction func negativeFeatures(_ sender: UIButton) {
        goToResultVC(withPositive: false)
    }
    
    
    @IBAction func goToRoot(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func goToResultVC(withPositive: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "resultVC") as? ResultViewController else { return }
        
        controller.titleText = withPositive ? "ПОЗИТИВНЫЕ КАЧЕСТВА" : "НЕГАТИВНЫЕ КАЧЕСТВА"
        
        if let first = data.first {
            controller.dataArray  = withPositive ? first.positive ?? [""] : first.negative ?? [""]
            controller.isPositive = withPositive ? true : false
        }
        self.present(controller, animated: true, completion: nil)
    }
    
}
