//
//  EnergyManager.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/25.
//

import UIKit


class EnergyManager {
    static let shared = EnergyManager()
    
    private var timer: Timer?
    
    private init() {
        startTimer()
    }
    
    private func startTimer() {
        // 创建一个定时器，在每天的晚上 23:59 触发
        let calendar = Calendar.current
        if let date = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: Date()) {
            let timeInterval = date.timeIntervalSinceNow
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(increaseEnergy), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func increaseEnergy() {
        // 在这里将能量值 X 增加 1234
        
        HealthManager.shared.readCalories(for: todayDate) { calories, progress, _ in
            guard let calories = calories , let progress = progress else{
                return
            }
            if let userCaroPoint = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
                let currentEnergy = userCaroPoint
                let newCaroPoint = currentEnergy + Int(calories)
                UserDataManager.shared.currentUserData?["CaloriesPoints"] = newCaroPoint
                UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CaloriesPoints", fieldValue: newCaroPoint)
            }
            
            if let userCheckPoint = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int {
                
                if progress >= 1 {
                    let currentCheckPoint = userCheckPoint
                    let newCheckPoint = currentCheckPoint + 1
                    
                    UserDataManager.shared.currentUserData?["CheckinPoints"] = newCheckPoint
                    UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CheckinPoints", fieldValue: newCheckPoint)
                }
                
            }
            
        }
        
        // 重新启动定时任务
        startTimer()
    }

}
