//
//  SocialNetworks.swift
//  FacesDetection
//
//  Created by Владимир Моисеев on 28.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Photos
import TwitterKit
import VK_ios_sdk

class SocialNetworks {
    
    static let shared = SocialNetworks()
    private var url = URL(string: "http://facesapp.me")
    
    private init() {}
    
    func postImageToInstagram(image: UIImage, vc: UIViewController) {
        guard let instagramURL = URL(string: "instagram://app") else { return }
        if UIApplication.shared.canOpenURL(instagramURL) {
            guard let image = image.scaleImageWithAspectToWidth(toWidth: 640) else { return }
            
            do {
                try PHPhotoLibrary.shared().performChangesAndWait {
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    
                    let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                    let shareURL = "instagram://library?LocalIdentifier=" + assetID
                    
                    
                    if let urlForRedirect = URL(string: shareURL) {
                        UIApplication.shared.open(urlForRedirect)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            
            let alert = UIAlertController(title: nil, message: "instagram not installed", preferredStyle: .alert)
            let install = UIAlertAction(title: "Установить", style: .default) { _ in
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
            }
            
            let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alert.addAction(install)
            alert.addAction(cancel)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func postImageToTwitter(image: UIImage, vc: UIViewController) {
        
        let composer = TWTRComposer()
        composer.setURL(url)
        composer.setImage(image)
        composer.show(from: vc) { result in
            if (result == .done) {
                print("Successfully composed Tweet")
            } else {
                let alert = UIAlertController(title: nil, message: "instagram not installed", preferredStyle: .alert)
                let install = UIAlertAction(title: "Установить", style: .default) { _ in
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
                }
                
                let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
                alert.addAction(install)
                alert.addAction(cancel)
                
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func postImageToFacebook(image: UIImage, vc: UIViewController) {
        
        let photo = FBSDKSharePhoto()
        photo.image = image
        photo.isUserGenerated = true
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        //content.ref = url
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = vc
        dialog.delegate = vc as! FBSDKSharingDelegate
        dialog.shareContent = content
        dialog.mode = .shareSheet
        dialog.show()
    }
    
    
    
    func postImageToVK(image: UIImage, vc: UIViewController) {
        
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
        shareDialog.text = "Faces"
        let img = VKUploadImage(image: image, andParams: nil)
        shareDialog.uploadImages = [img as Any]
        shareDialog.shareLink = VKShareLink(title: "Посетите наш сайт", link: url)
        shareDialog.completionHandler = { VKShareDialogController, result in
            vc.dismiss(animated: true, completion: nil)
        }
        vc.present(shareDialog, animated: true, completion: nil)
    }
    
    
}




