//
//  AppDelegate.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import FirebaseCore

import BackgroundTasks
import GoogleMobileAds

var earliestBeginDate: Date?
var updateStep = 0
var updateCaro = 0
var updatePrgress = 0.0

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let updateDaily = "com.fitbeats.dailytask"
    let healthManager = HealthManager.shared
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let _ = EnergyManager.shared
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: updateDaily, using: nil) { task in
            guard let updateDatatask = task as? BGAppRefreshTask else { return }
            // 在這裡執行你的每日背景工作
            self.performDailyBackgroundTask(updateDatatask)
        }
        
        scheduleDailyBackgroundTask()
        
        
        
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
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //刪除快取
        logImage.shared.startPurgeTimer()
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
    
    func performDailyBackgroundTask(_ task: BGAppRefreshTask) {
        if isForegroundTaskCompleted == false {
            let currentDate = Date()
            let calendar = Calendar.current
            // 检查当前时间是否在触发时间之后
            guard let earliestBeginDate = earliestBeginDate else { return }
            
            if currentDate > earliestBeginDate {
                // 如果是的话，将日期回滚到前一天
                if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) {
                    // 更新数据时使用前一天的日期
                    searchHealthData(date: previousDay)
                    
                }
            } else {
                // 否则，更新数据时使用当前日期
                searchHealthData(date: currentDate)
                
            }
            
            task.setTaskCompleted(success: true)
        } else {
            isForegroundTaskCompleted = false
            task.setTaskCompleted(success: true)
        }
    }
    
    func scheduleDailyBackgroundTask() {
        // 創建每日背景任務請求
        let taskRequest = BGAppRefreshTaskRequest(identifier: updateDaily)
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let setTodayDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate) {
            
            // 設置每天的特定時間觸發
            taskRequest.earliestBeginDate = Calendar.current.date(bySettingHour: 23, minute: 30, second: 00, of: setTodayDate)
            earliestBeginDate = taskRequest.earliestBeginDate
            do {
                // 提交每日背景任務請求
                try BGTaskScheduler.shared.submit(taskRequest)
                
            } catch {
                print("無法提交每日背景任務請求：\(error.localizedDescription)")
            }
        }
    }
    
    private func searchHealthData(date: Date) {
        HealthManager.shared.readStepCount(for: date)  { step in
            guard step != 0 else{
                return
            }
            updateStep = Int(step)
        }
        HealthManager.shared.readCalories(for: date) { calories, progress, _ in
            guard let calories = calories , let progress = progress else{
                return
            }
            
            updateCaro = Int(calories)
            updatePrgress = progress
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        scheduleDailyBackgroundTask()
    }
    
}




