//
//  healthManager.swift
//  testHealthKit
//
//  Created by YuCheng on 2023/8/26.
//


import HealthKit
import UIKit
import CoreLocation

class HealthManager {
    
    var stepType: HKQuantityType
    var activeEnergyType: HKQuantityType
    var stepDistance: HKQuantityType
    var activeTime: HKQuantityType
    var heartRate: HKQuantityType
    var cyclingDistance: HKQuantityType
    var swimmingDistance: HKQuantityType
    var wheelchairDistance: HKQuantityType
    var snowSportsDistance: HKQuantityType
    
    static let shared = HealthManager()
    private let healthStore = HKHealthStore()
    var typesToShare: Set<HKSampleType> = []
    var typesToRead: Set<HKObjectType> = []
    
    init() {
            guard HKHealthStore.isHealthDataAvailable() else {
                fatalError("Your device can't use HealthKit")
            }
            
            
            if let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
               let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
               let stepDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
               let cyclingDistance = HKObjectType.quantityType(forIdentifier: .distanceCycling),
               let swimmingDistance = HKObjectType.quantityType(forIdentifier: .distanceSwimming),
               let wheelchairDistance = HKObjectType.quantityType(forIdentifier: .distanceWheelchair),
               let snowSportsDistance = HKObjectType.quantityType(forIdentifier: .distanceDownhillSnowSports),
               let activeTime = HKObjectType.quantityType(forIdentifier: .appleMoveTime),
               let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) {
                    self.stepType = stepType
                    self.activeEnergyType = activeEnergyType
                    self.stepDistance = stepDistance
                    self.activeTime = activeTime
                    self.heartRate = heartRate
                    self.cyclingDistance = cyclingDistance
                    self.snowSportsDistance = snowSportsDistance
                    self.swimmingDistance = swimmingDistance
                    self.wheelchairDistance = wheelchairDistance
                typesToRead = [stepType,activeEnergyType,.activitySummaryType(),stepDistance,activeTime,heartRate,.workoutType() , HKSeriesType.workoutRoute()
                ]
                } else {
                    fatalError("Invalid step count or active energy identifier")
                }
            
        }
   
    
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
        
        func checkHealthDataAuthorizationStatus(completion: @escaping (Bool, Error?) -> Void) {
            
            healthStore.getRequestStatusForAuthorization(toShare: typesToShare, read: typesToRead) { status, error in
                if let error = error {
                    print("getRequestStatusForAuthorization fail: \(error)")
                    completion(false,error)
                    return
                }
                
                switch status {
                    
                case .shouldRequest :
                    completion(false,error)
                case .unknown :
                    completion(false,error)
                case .unnecessary :
                    completion(true,error)
                @unknown default:
                    fatalError("checkStatusForAuthorization fail")
                }
            }
            
        }
        
        func setPredicate(for date: Date) -> NSPredicate{
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
            
            let predicvate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
            return predicvate
        }
        
        func readStepCount(for date: Date, completion: @escaping (Double) -> Void) {
            let predicate = setPredicate(for: date)
            
            let stepQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    if let error = error {
                        print("Error fetching step count: \(error.localizedDescription)")
                        completion(0)
                        return
                    }
                    return
                }
                
                let steps = sum.doubleValue(for: HKUnit.count())
                completion(steps)
                
            }
            healthStore.execute(stepQuery)
        }
        
        func readCalories(for date: Date, completion: @escaping (Double?,Double?,Double?) -> Void) {
            
            let predicate = setPredicate(for: date)
            
            let caloriesSummary = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
                if let error = error {
                    print("Error fetching active energy burned goal: \(error.localizedDescription)")
                    completion(nil,nil,nil)
                    return
                }
                
                guard let summaries = summaries else{
                    return
                }
                
                if summaries.isEmpty {
                    print("caloriesSummary is empty")
                    completion(nil,nil,nil)
                } else {
                    guard let summary = summaries.first else {
                        return
                    }
                    
                    let activeEnergyBurned = summary.activeEnergyBurned
                    let calories = activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                    let activeEnergyBurnedGoal = summary.activeEnergyBurnedGoal
                    let goalValue = activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
                    
                    let progress = calories / goalValue
                    
                    
                    //print("日期：\(dateString), 卡路里總和：\(calories), 目標： \(goalValue)")
                    completion(calories,progress,goalValue)
                }
                
                
                
            }
            healthStore.execute(caloriesSummary)
        }
        
        
        func setQuery(type: HKQuantityType, predicate: NSPredicate, completion: @escaping (HKStatisticsQuery,HKStatistics?,Error?) -> Void) -> HKStatisticsQuery{
            
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
                completion(query,result,error)
            }
            return query
        }
        
        func readStepDistance(for date: Date, completion: @escaping (Double) -> Void){
            let predicate = setPredicate(for: date)
            
            let stepQuery = setQuery(type: stepDistance, predicate: predicate) { query, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    if let error = error {
                        print("Error fetching step distance: \(error.localizedDescription)")
                        completion(0)
                    }
                    return
                }
                let distance = sum.doubleValue(for: HKUnit.meter()) / 1000.0
                completion(distance)
            }
            healthStore.execute(stepQuery)
        }
        
        func readActiveTime(for date: Date, completion: @escaping (Double?) -> Void){
            let predicate = setPredicate(for: date)
            
            let stepQuery = setQuery(type: activeTime, predicate: predicate) { query, result, error in
                guard let result = result, let sum = result.sumQuantity() else {
                    if let error = error {
                        print("Error fetching step count: \(error.localizedDescription)")
                        completion(nil)
                    }
                    return
                }
                let activeTime = sum.doubleValue(for: HKUnit.minute())
                completion(activeTime)
            }
            healthStore.execute(stepQuery)
        }
        
    
    //MARK: workoutdata
    
    func readWorkData(for date: Date, completion: @escaping ([HKWorkout]?) -> Void) {
        let predicate = setPredicate(for: date)
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            if let error = error {
                print("search workData fail: \(error)")
            }
            
            if let workoutSamples = samples as? [HKWorkout] {
                completion(workoutSamples)
            }
            
        }
        healthStore.execute(query)
    }
    
    func searchWorkOutData(_ workout: HKWorkout, completion: @escaping (String?,Error?) -> Void) {
        
       
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        let routeType = HKSeriesType.workoutRoute()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let routeQuery = HKSampleQuery(sampleType: routeType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                print("searchWorkOutData fail : \(error)")
                completion(nil, error)
                return
            }
            guard let samples = samples, !samples.isEmpty else {
                print("samples is empty")
                completion(nil,nil)
                return
            }
            if let routes = samples as? [HKWorkoutRoute],
               let route = routes.first {
                self.searchRoute(route) { locationinfo, error in
                    if let error = error {
                        print("searchRoute fail :\(error)")
                    }
                    completion(locationinfo,nil)
                }
            }
                }
        
        healthStore.execute(routeQuery)
            }
        
    func searchRoute(_ route: HKWorkoutRoute, completion: @escaping (String?,Error?) -> Void) {
        let routeQuery = HKWorkoutRouteQuery(route: route) { query, location, result, error in
            if let error = error {
                print("searchRoutelocation fail : \(error)")
                completion(nil, error)
                return
            }
            if result {
                if let location = location?.first {
                    self.reverseGeocodeLocation(location){ locationinfo, error in
                        if let error = error {
                            print("reverseGeocodeLocation fail :\(error)")
                        }
                        completion(locationinfo, nil)
                    }
                }
            }
        }
        healthStore.execute(routeQuery)
        }
    
    func reverseGeocodeLocation(_ location: CLLocation, completion: @escaping (String?,Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("反向地理编码出错：\(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    let locationinfo = "\(city)"
                    completion(locationinfo, nil)
                } else {
                    let locationinfo = "無法確定城市和區域"
                    completion(locationinfo, nil)
                }
            } else {
                let locationinfo = "無法確定地理資訊"
                completion(locationinfo, nil)
            }
        }
    }
    
    func searchHeartRate (_ workout: HKWorkout, completion: @escaping (Double?,Error?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        
        // 創建心率查詢
        let heartRateQuery = HKSampleQuery(sampleType: heartRate, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            if let error = error {
                print("無法獲取心率數據: \(error.localizedDescription)")
                completion(nil,error)
                      return
            }
            //如果為空也一種錯誤
            guard let heartRateSamples = samples as? [HKQuantitySample] else {
                print("無法獲取心率數據: \(error?.localizedDescription ?? "未知錯誤")")
                completion(0,error)
                return
            }
            var totalHeartRate = 0.0
                for sample in heartRateSamples {
                    let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    totalHeartRate += heartRate
                }
                
                // 計算平均心率
                let averageHeartRate = totalHeartRate / Double(heartRateSamples.count)
                completion(averageHeartRate,nil)
                      
        }
        healthStore.execute(heartRateQuery)
    }
    
}

extension UIViewController {
    
    
    func showHealthKitAuthorizationAlert() {
            let alertController = UIAlertController(title: "沒有資料", message: "您是否尚未授權呢？\n此應用需要訪問您的健康數據。\n請點擊“設置”以前往授權。", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "設置", style: .default) { (_) in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
}



