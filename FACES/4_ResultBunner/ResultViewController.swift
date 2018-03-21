//
//  ResultViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 19.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleOfResult: UILabel!
    @IBOutlet weak var topBarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarHeight: NSLayoutConstraint!
    
    
    var documentController: UIDocumentInteractionController!
    var dataArray = [String]()
    var imageForShare: UIImage?
    var titleText : String?
    var isPositive: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topBarHeight.constant = LayHelper.shared.topHeight
        bottomBarHeight.constant = LayHelper.shared.bottomBarHeight
        tableView.delegate = self
        tableView.dataSource = self
        titleOfResult.text = titleText ?? ""
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageForShare = textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 130))
    }
    
    
    
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 

    
    @IBAction func facebook(_ sender: UIButton) {
        
        SocialNetworks.shared.postImageToFacebook(image: imageForShare ?? UIImage(named: "smile")!, vc: self)
    }
    
    
    @IBAction func vkontakte(_ sender: UIButton) {
        
        SocialNetworks.shared.postImageToVK(image: imageForShare ?? UIImage(named: "smile")!, vc: self)
    }
    
    
    @IBAction func twitter(_ sender: UIButton) {
        
        SocialNetworks.shared.postImageToTwitter(image: imageForShare ?? UIImage(named: "smile")!, vc: self)
    }
    
    
    
    @IBAction func instagram(_ sender: UIButton) {
        
        SocialNetworks.shared.postImageToInstagram(image: imageForShare ?? UIImage(named: "smile")!, vc: self)
    }
    
    
    
    @IBAction func sharePressed(_ sender: UIButton) {
        
        let imageToShare = [textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 130))]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view /// !!! so that iPads won't crash
        activityViewController.excludedActivityTypes = [ .postToFacebook, .postToTwitter]
        
        //Проверить на ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.sourceView = self.view
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
}

