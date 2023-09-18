//
//  AppDelegate.swift
//  AlfaNews
//
//  Created by Adhitya Bagas on 16/09/23.
//

import UIKit
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachabilityManager = NetworkUtilsReachabilityManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        reachabilityManager.startMonitoring()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        reachabilityManager.manager?.stopListening()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

