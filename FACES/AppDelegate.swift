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
        
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                LayHelper.shared.bottomBarHeight = 105
                LayHelper.shared.topHeight = 71
            }
        }
        
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"sKRPTlhnCc1nFhrfcxHhW3Szn", consumerSecret:"86rsCUUfm7m8Xnjdm8SfnFnduPDLLVcB1z44cTYN3P310MoCxQ")
        
        if isNewLevel {
            isNewLevel = false
           
            let pswdChars = Array("abcdefghijklmnopqrstuvwxyz")
            let rndPswd = String((0..<8).map{ _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})
            UserDefaults.standard.set(rndPswd, forKey: "FileListName")
            print("rndPswd - *\(rndPswd)*")
            FaceAPI.createFaceList(withName: rndPswd) { (a) in
                print(a ?? "no JSONDictionary")
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

