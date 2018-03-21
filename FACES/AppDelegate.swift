//
//  AppDelegate.swift
//  VisionDetection
//
//  Created by Wei Chieh Tseng on 09/06/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit
import VK_ios_sdk
import FBSDKCoreKit





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var isNewLevel: Bool {
        get { return UserDefaults.standard.value(forKey: "isNewLevel") as? Bool ?? true }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "isNewLevel")
            userDefaults.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                LayHelper.shared.bottomBarHeight = 105
                LayHelper.shared.topHeight = 71
            }
        }
        
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"sKRPTlhnCc1nFhrfcxHhW3Szn", consumerSecret:"86rsCUUfm7m8Xnjdm8SfnFnduPDLLVcB1z44cTYN3P310MoCxQ")

        return true
    }
    

    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let appId = FBSDKSettings.appID()
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(String(describing: appId))") {//&& url.host ==  "authorize"
// if #available(iOS 9.0, *) {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        } else {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        
       
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        VKSdk.processOpen(url, fromApplication: sourceApplication)
        
        return true
    }
    
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
    
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Persons")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
    
    
}

