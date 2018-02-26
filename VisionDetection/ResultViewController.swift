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

class ResultViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleOfResult: UILabel!
    
    var dataArray = [String]()
    var titleText : String?
    var isPositive: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        titleOfResult.text = titleText ?? ""

    }
    
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    
    
  
    
/// Social ____________________________________
    
    @IBAction func facebook(_ sender: UIButton) {
        
        let photo = FBSDKSharePhoto()
        photo.image = textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250))
        photo.isUserGenerated = true
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.delegate = self
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
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
        shareDialog.text = "This post created using #vksdk #ios"
        
        let img = VKUploadImage(image: self.textToImage(drawText: self.getString(arr: self.dataArray), inImage: UIImage(named: self.isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)), andParams: nil)
        shareDialog.uploadImages = [img as Any]
        shareDialog.shareLink = VKShareLink(title: "Super puper link, but nobody knows", link: NSURL(string: "https://vk.com/dev/ios_sdk")! as URL!)
        shareDialog.completionHandler = { VKShareDialogController, result in
            self.dismiss(animated: true, completion: nil)
        }
        self.present(shareDialog, animated: true, completion: nil)
    }
    
    
    @IBAction func twitter(_ sender: UIButton) {
        
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
    }
    
    
    
    @IBAction func instagram(_ sender: UIButton) {
        
        postImageToInstagram(image: textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)))
    }
    
    
    
    @IBAction func sharePressed(_ sender: UIButton) {
        
        let imageToShare = [ textToImage(drawText: getString(arr: dataArray), inImage: UIImage(named: isPositive ? "positive" : "negative")!, atPoint: CGPoint(x: 50, y: 250)) ]
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






//MARK: TableView
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let count: Int = dataArray[indexPath.row].count
        
        return count > 28 ? 50 : 20
    }
}









//MARK: Create Image
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
        
        let rect = CGRect(origin: point, size: CGSize(width: image.size.width / 2, height: image.size.height))//image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func getString(arr: [String]) -> String {
        
        let str = arr.map { (string) in return  "\n \u{2022}" + " " + string }.joined(separator: "")
        
        return str
    }
}


//MARK: Instagram
extension ResultViewController {
    
    func postImageToInstagram(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if error != nil {
            print(error ?? "Unknown Error")
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
            let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.open(URL(string: u)!)
            } else {
                let alert = UIAlertController(title: nil, message: "instagram not installed", preferredStyle: .alert)
                let install = UIAlertAction(title: "Установить", style: .default) { _ in
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
                }
                let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
                
                alert.addAction(install)
                alert.addAction(cancel)
                
                present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
}



//MARK: Facebook
extension ResultViewController : FBSDKSharingDelegate {
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
    }
    
    
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
    
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
    }
}







