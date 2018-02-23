//
//  ResultViewController.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 19.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import FacebookShare
import FBSDKShareKit
import Photos
import TwitterKit
import VK_ios_sdk

class ResultViewController: UIViewController, UIDocumentInteractionControllerDelegate {//VKSdkUIDelegate, VKSdkDelegate {
    
//    func vkSdkShouldPresent(_ controller: UIViewController!) {
//        print("vkSdkShouldPresent")
//    }
//
//    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
//        print("vkSdkNeedCaptchaEnter")
//    }
//
//    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
//        print("vkSdkAccessAuthorizationFinished")
//    }
//
//    func vkSdkUserAuthorizationFailed() {
//        print("vkSdkUserAuthorizationFailed")
//    }
//

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleOfResult: UILabel!
    
    var dataArray = [String]()
    var titleText : String?
    var isPositive: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //dataArray = ["1","2", "3", "4"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleOfResult.text = titleText ?? ""
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getString(arr: [String]) -> String {
        let str = arr.map { (string) in return  "\n \u{2022}" + " " + string }.joined(separator: "")
        
        return str
    }

    
    func postImageToInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //self.image(_:didFinishSavingWithError:contextInfo:))
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            print(error)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject as? PHAsset {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(NSURL(string: u)! as URL)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
    // Share results to social networks
    
    @IBAction func facebook(_ sender: UIButton) {
        
        let photo = Photo(image: textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)), userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            
        }
        
        do {
            try shareDialog.show()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    @IBAction func vkontakte(_ sender: UIButton) {
        
        
        
        VKSdk.initialize(withAppId: "6381010")
        
        VKSdk.wakeUpSession([VK_PER_WALL, VK_PER_PHOTOS, VK_PER_OFFLINE]) { state, error in
            if (state == .authorized) {
                print("Authorized")
                
            } else if error != nil {
                print(error?.localizedDescription ?? "_UnknownError_")
            } else {
                print("NotAuthorized")
                let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
                if VKSdk.vkAppMayExists() == true {
                    VKSdk.authorize(scopePermissions, with: .unlimitedToken)
                } else {
                    VKSdk.authorize(scopePermissions, with: [.disableSafariController, .unlimitedToken])
                }
            }
        }
        
        
        let shareDialog = VKShareDialogController()
        //1
        shareDialog.text = "This post created using #vksdk #ios"
        //2
        
        let img = VKUploadImage(image: self.textToImage(drawText: self.getString(arr: self.dataArray), inImage: UIImage(named: self.isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)), andParams: nil)
        shareDialog.uploadImages = [img as Any]
        //3
        shareDialog.shareLink = VKShareLink(title: "Super puper link, but nobody knows", link: NSURL(string: "https://vk.com/dev/ios_sdk")! as URL!)
        //4
        shareDialog.completionHandler = { VKShareDialogController, result in
            self.dismiss(animated: true, completion: nil)
        }
        //5
        self.present(shareDialog, animated: true, completion: nil)
    }

    
//
//    private func presentTweetViewController() {
//        let composer = TWTRComposerViewController(initialText: "FacesApp", image: UIImage(named: "smile")!, videoData: nil)
//        composer.delegate = self
//        present(composer, animated: true, completion: nil)
//    }
    
    
    @IBAction func twitter(_ sender: UIButton) {
        /// если юзать делегейт - необходимо логиниться
        //presentTweetViewController()
        
        let composer = TWTRComposer()
        composer.setText("Hello World.")
        composer.setImage(UIImage(named: "smile")!)
        composer.show(from: self) { result in
            if (result == .done) {
            print("Successfully composed Tweet")
            } else {
            print("Cancelled composing")
            }
        }
        
//        composer.show(from: self, completion: {(result) -> Void in
//            print("---------------------------\(result)")
//        })
    }
    
    
    
    @IBAction func instagram(_ sender: UIButton) {

        postImageToInstagram(image: textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)))
    }
    
    
    
    @IBAction func sharePressed(_ sender: UIButton) {
        
        
        // set up activity view controller
        let imageToShare = [ textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)) ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ .postToFacebook, .postToTwitter]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}


extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
}



extension ResultViewController {
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 40)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



//extension ResultViewController: TWTRComposerViewControllerDelegate {
//    func composerDidCancel(_ controller: TWTRComposerViewController) {
//        dismiss(animated: false, completion: nil)
//    }
//
//    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
//        dismiss(animated: false, completion: nil)
//    }
//
//    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
//        dismiss(animated: false, completion: nil)
//    }
//}










