//
//  EnergyManager.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/25.
//

import UIKit

var isForegroundTaskCompleted = false
class EnergyManager {
    static let shared = EnergyManager()
    
    private var timer: Timer?
    
    private init() {
        startTimer()
    }
    
    private func startTimer() {
        // 获取当前日期和时间
        let currentDate = Date()
        
        // 获取日历对象
        let calendar = Calendar.current
        
        // 获取今天的日期
        if let todayDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate) {
            
            // 设置触发时间为每天的晚上23:59:59
            if let endDate = calendar.date(bySettingHour: 23, minute: 55, second: 0, of: todayDate) {
                
                // 计算时间间隔，这里是计算到指定时间的时间差
                let timeInterval = endDate.timeIntervalSince(currentDate)
                
                // 如果时间间隔小于等于0，表示今天的触发时间已经过去，将触发时间设置为明天的时间
                if timeInterval <= 0 {
                    if let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate),
                       let nextEndDate = calendar.date(bySettingHour: 23, minute: 55, second: 0, of: tomorrowDate) {
                        
                        // 计算到明天触发时间的时间间隔
                        let nextTimeInterval = nextEndDate.timeIntervalSince(currentDate)
                        
                        // 创建定时器，在明天触发
                        timer = Timer.scheduledTimer(timeInterval: nextTimeInterval, target: self, selector: #selector(increaseEnergy), userInfo: nil, repeats: false)
                    }
                } else {
                    // 创建定时器，在今天触发
                    timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(increaseEnergy), userInfo: nil, repeats: false)
                }
            }
        }
    }

    
    @objc private func increaseEnergy() {
        // 在这里将能量值 X 增加 1234
        print("啟動囉")
    
        HealthManager.shared.readStepCount(for: todayDate)  { step in
            if step < 1000 {
                let increaseNumber = 0
                NotificationCenter.default.post(name: .updateMonster, object: increaseNumber)
            } else if step < 2000 {
                let increaseNumber = 3
                NotificationCenter.default.post(name: .updateMonster, object: increaseNumber)
            } else if step < 3000 {
                let increaseNumber = 4
                NotificationCenter.default.post(name: .updateMonster, object: increaseNumber)
            } else {
                let increaseNumber = 5
                NotificationCenter.default.post(name: .updateMonster, object: increaseNumber)
            }
        }


        HealthManager.shared.readCalories(for: todayDate) { calories, progress, _ in
            guard let calories = calories , let progress = progress else{
                NotificationCenter.default.post(name: .failGetData, object: nil)
                return
            }
            if let userCaroPoint = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
                let currentEnergy = userCaroPoint
                let newCaroPoint = currentEnergy + Int(calories)
                
                
                UserDataManager.shared.currentUserData?["CaloriesPoints"] = newCaroPoint
                UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CaloriesPoints", fieldValue: newCaroPoint)
                UserDataManager.shared.fetchUserData()
            }
            
            if let userCheckPoint = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int {
                
                if progress >= 1 {
                    let currentCheckPoint = userCheckPoint
                    let newCheckPoint = currentCheckPoint + 1
                    
                    UserDataManager.shared.currentUserData?["CheckinPoints"] = newCheckPoint
                    UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CheckinPoints", fieldValue: newCheckPoint)
                    UserDataManager.shared.fetchUserData()
                }
                
            }
            
        }
        isForegroundTaskCompleted = true
        // 重新启动定时任务
        startTimer()
    }

}
