//
//  CheckViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 19.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {

    
    var faceId: String?
    var imageSent : UIImage?
    var negative_Positive: [String: [String]]?
    var oneFace = false
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        image.image = imageSent ?? UIImage(named: "smile")
    }
    
    

    @IBAction func positiveFeatures(_ sender: UIButton) {
        goToResultVC(withPositive: true)
    }

    
    
    
    @IBAction func negativeFeatures(_ sender: UIButton) {
        goToResultVC(withPositive: false)
    }
    
    
    @IBAction func goToRoot(_ sender: UIButton) {
        
        if oneFace {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    func goToResultVC(withPositive: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "resultVC") as? ResultViewController else { return }
        
        controller.titleText = withPositive  ? NSLocalizedString("positive", comment: "") : NSLocalizedString("negative", comment: "")
        controller.isPositive = withPositive ? true : false
        controller.dataArray = withPositive ? negative_Positive?["good"] ?? [""] : negative_Positive?["bad"] ?? [""]
        
        self.present(controller, animated: true, completion: nil)
    }
    
}
