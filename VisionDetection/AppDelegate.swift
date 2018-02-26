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



let myTempData : [PersonModel] = [
    PersonModel(image: UIImage(named: "1")!,
                positive: ["1","чувственность", "уверенность в себе", "отзывчивость", "искренность", "исполнительность"],
                negative: ["1", "не решительность", "недисциплинированность", "нет самоконтроля", "безответственность", "склонны ко лжи"]),
    PersonModel(image: UIImage(named: "2")!,
                positive: ["2", "уверенность", "идейность", "авторитетность", "мужество", "бесстрашие", "интеллигентность", "чувствительность", "предусмотрительность", "справедливость"],
                negative: ["2", "заносчивость",  "закрытость в любви", "скрытность", "недоверчивость", "горделивость", "непостоянство"]),
    PersonModel(image: UIImage(named: "3")!,
                positive: ["3", "доброта", "мягкость", "спокойствие", "хорошо развито воображение", "склонность к поэзии", "интеллектуальность", "хорошо развито чувство юмора", "большая сила воли", "реалистичность"],
                negative: ["3", "влюбчивость", "непостоянство", "капризность", "одиночество", "эгоцентризм", "заносчивость"]),
    PersonModel(image: UIImage(named: "4")!,
                positive: ["4",  "интеллектуальность", "чувственность", "добродушие", "оптимизм", "вдумчивость", "мечтательность", "богатое воображение", "дипломатичность", "вежливость", "компромиссность"],
                negative: ["4", "неопределённость", "неустойчивость", "нерешительность", "капризность", "недальновидность", "нетерпеливость", "неуравновешенность"]),
    PersonModel(image: UIImage(named: "5")!,
                positive: ["5", "независимость", "гениальности", "целеустремленность", "чувствительность", "наблюдательность", "артистичность", "осторожность", "свободолюбие", "смелость"],
                negative: ["5", "хитрость", "неуживчивость", "ревнивость", "изворотливость", "противоречивость", "упрямство"]),
    PersonModel(image: UIImage(named: "6")!,
                positive: ["6", "доброжелательность", "интеллигентность", "интеллектуальность", "чувственность", "коммуникабельность", "артистичность", "самодостаточность", "пунктуальность", "верность"],
                negative: ["6", "ленивость", "не свойственен дух борца", "отсутствие амбиций", "чрезмерная скрупулёзность", "ревнивость", "слабость", "эгоизм"]),
    PersonModel(image: UIImage(named: "7")!,
                positive: ["7", "чувственность", "сильный характер", "уверенность в себе", "остроумие", "коммуникабельность", "мягкость характера", "оптимистичность", "практический/технический склад ума", "мужественность"],
                negative: ["7", "бессердечность", "суровость", "грубость", "тугодумство", "склонность ко лжи", "стремление к доминированию", "вспыльчивость", "упрямство"]),
    PersonModel(image: UIImage(named: "8")!,
                positive: ["8", "смелость", "стремление к обучению и познанию новому", "оптимистичность", "гуманитарный склад ума", "добродушие", "миролюбие", "лидерские качества"],
                negative: ["8", "чрезмерная чистоплотность", "гордыня", "расточительность", "самовлюблённость", "беззаботность", "нетерпеливость", "чрезмерная откровенность"]),
    PersonModel(image: UIImage(named: "9")!,
                positive: ["9",  "индивидуальность", "прирожденный руководитель", "реалистичность", "практический/технический склад ума", "скрупулёзность", "интеллектуальность", "рассудительность", "добросовестность", "чёткость"],
                negative: ["9", "рассеянность", "гордость", "высокомерие", "неуживчивость", "концентрированность на личных проблемах", "навязчивость", "резкость"]),
    PersonModel(image: UIImage(named: "10")!,
                positive: ["10", "спокойствие", "добродушие", "неторопливость", "реалистичность", "постоянство", "аналитический/математический склад ума", "проницательность ума", "настойчивость"],
                negative: ["10", "закрытость", "самовлюблённость", "упрямство", "непостоянство", "тщеславность", "не восприятие критики", "властность", "хитрость"])
]





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
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"sKRPTlhnCc1nFhrfcxHhW3Szn", consumerSecret:"86rsCUUfm7m8Xnjdm8SfnFnduPDLLVcB1z44cTYN3P310MoCxQ")
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if isNewLevel {
            isNewLevel = false
           
            let pswdChars = Array("abcdefghijklmnopqrstuvwxyz")
            let rndPswd = String((0..<8).map{ _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})
            UserDefaults.standard.set(rndPswd, forKey: "FileListName")
            
            print("rndPswd - *\(rndPswd)*")
            // UserDefaults.standard.string(forKey: "FileListName")
            
            FaceAPI.createFaceList(withName: rndPswd) { (a) in
        
                print(a)
                ///нужно обработать ошибку, если нет интернета
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.saveToAll(arrPersons: myTempData, fileList: rndPswd)
            }
        }
            
        
        
        
        return true
    }
    
    
    
    func saveToAll(arrPersons: [PersonModel], fileList: String) {
        
        
        for per in arrPersons {
            
            FaceAPI.addFaceToFaceList(image: per.image, toFileList: fileList) { (id) in
                
                if let idForData = id {
                    DispatchQueue.main.async {
                        print("image - \(per.image.description)")
                        
                        let pers = Person()
                        pers.id = idForData
                        pers.positive = per.positive
                        pers.negative = per.negative
                        
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        let contex = appDelegate.persistentContainer.viewContext
                        
                        do {
                            try self.persistentContainer.viewContext.save()
                            print("saved")
                        } catch {
                            print("error")
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let appId = FBSDKSettings.appID()
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(String(describing: appId))") {//&& url.host ==  "authorize" { // facebook
           // if #available(iOS 9.0, *) {
                return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//         ?   
        } else {
            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
        
       
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Persons")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
    
    
}

