//
//  AppDelegate.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    let dataControllerClass = DataControllerClass(modelName: "VirtualTouristDataModel")
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataControllerClass.load()
        
        let ctrl = mainStoryboard.instantiateViewController(withIdentifier: "TravelMapViewController") as! TravelMapViewController
        ctrl.dataControllerClass = dataControllerClass
        let Nav = UINavigationController(rootViewController: ctrl)
        self.window?.rootViewController = Nav
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

