//
//  AppDelegate.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let healthManager = HealthManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let _ = EnergyManager.shared //初始化時間生成器
        
        ValueTransformer.setValueTransformer(HKWorkoutTransformer(), forName: NSValueTransformerName(rawValue: "HKWorkoutTransformer"))
        healthManager.requestAuthorization { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
            
            if success {
                NotificationCenter.default.post(name: Notification.Name("HealthKitAuthorizationSuccess"), object: nil)
                print("HealthKit authorization granted.")
            }
        }
        return true
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

