//
//  setSportIcon.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/9/6.
//

import HealthKit
import UIKit

class setWorkCellData {
    
    static let shared = setWorkCellData()
    private init() {}
    
    //MARK: 判斷運動類型
    func setCellIconandTitle(for workout: HKWorkout) ->  (UIImage?, String, String?) {
        let activityType = workout.workoutActivityType
        let isIndoorWorkout = isIndoorWorkout(workout: workout)
        var symbolName: String
        var title: String
        
        var caloriesBurnedString: String?
        
        switch activityType {
        case .americanFootball:
            title = "美式足球"
            symbolName = "figure.american.football"
        case .archery:
            title = "射箭"
            symbolName = "figure.archery"
        case .australianFootball:
            title = "澳式足球"
            symbolName = "figure.australian.football"
        case .badminton:
            title = "羽球"
            symbolName = "figure.badminton"
        case .barre:
            title = "芭蕾"
            symbolName = "figure.barre"
        case .baseball:
            title = "棒球"
            symbolName = "figure.baseball"
        case .basketball:
            title = "籃球"
            symbolName = "figure.basketball"
        case .bowling:
            title = "保齡球"
            symbolName = "figure.bowling"
        case .boxing:
            title = "拳擊"
            symbolName = "figure.boxing"
        case .cardioDance:
            title = "舞蹈"
            symbolName = "figure.dance"
        case .climbing:
            title = "攀岩"
            symbolName = "figure.climbing"
        case .cooldown:
            title = "緩和運動"
            symbolName = "figure.cooldown"
        case .coreTraining:
            title = "核心訓練"
            symbolName = "figure.core.training"
        case .cricket:
            title = "板球"
            symbolName = "figure.cricket"
        case .crossCountrySkiing:
            title = "越野滑雪"
            symbolName = "figure.skiing.crosscountry"
        case .crossTraining:
            title = "交叉訓練"
            symbolName = "figure.cross.training"
        case .curling:
            title = "冰壺"
            symbolName = "figure.curling"
        case .cycling:
            if isIndoorWorkout {
                title = "室內健身車"
                symbolName = "figure.indoor.cycle"
            } else {
                title = "室外自行車"
                symbolName = "figure.outdoor.cycle"
            }
        case .discSports:
            title = "飛盤運動"
            symbolName = "figure.disc.sports"
        case .downhillSkiing:
            title = "高山滑雪"
            symbolName = "figure.skiing.downhill"
        case .elliptical:
            title = "橢圓機"
            symbolName = "figure.elliptical"
        case .equestrianSports:
            title = "馬術運動"
            symbolName = "figure.equestrian.sports"
        case .fencing:
            title = "擊劍"
            symbolName = "figure.fencing"
        case .fishing:
            title = "釣魚"
            symbolName = "figure.fishing"
        case .fitnessGaming:
            title = "健身電玩"
            symbolName = "gamecontroller.fill"
        case .flexibility:
            title = "柔軟操"
            symbolName = "figure.flexibility"
        case .functionalStrengthTraining:
            title = "功能性肌力訓練"
            symbolName = "figure.strengthtraining.functional"
        case .golf:
            title = "高爾夫"
            symbolName = "figure.golf"
        case .gymnastics:
            title = "體操"
            symbolName = "figure.gymnastics"
        case .handCycling:
            title = "手輪"
            symbolName = "figure.hand.cycling"
        case .handball:
            title = "手球"
            symbolName = "figure.handball"
        case .highIntensityIntervalTraining:
            title = "高強度間歇訓練"
            symbolName = "figure.highintensity.intervaltraining"
        case .hiking:
            title = "健行"
            symbolName = "figure.hiking"
        case .hockey:
            title = "曲棍球"
            symbolName = "figure.hockey"
        case .hunting:
            title = "打獵"
            symbolName = "figure.hunting"
        case .jumpRope:
            title = "跳繩"
            symbolName = "figure.jumprope"
        case .kickboxing:
            title = "踢拳"
            symbolName = "figure.kickboxing"
        case .lacrosse:
            title = "袋棍球"
            symbolName = "figure.lacrosse"
        case .martialArts:
            title = "武術"
            symbolName = "figure.martial.arts"
        case .mindAndBody:
            title = "身心運動"
            symbolName = "figure.mind.and.body"
        case .mixedCardio:
            title = "混合有氧"
            symbolName = "figure.mixed.cardio"
        case .paddleSports:
            title = "輕艇運動"
            symbolName = "oar.2.crossed"
        case .pickleball:
            title = "匹克球"
            symbolName = "figure.pickleball"
        case .pilates:
            title = "皮拉提斯"
            symbolName = "figure.pilates"
        case .play:
            title = "玩樂"
            symbolName = "figure.play"
//        case .preparationAndRecovery:
//            title = "玩樂"
//            symbolName = "figure.play" //v
//
        case .racquetball:
            title = "美式壁球"
            symbolName = "figure.racquetball"
            
        case .rowing:
            title = "划船機"
            symbolName = "figure.rower"
        case .rugby:
            title = "橄欖球"
            symbolName = "figure.rugby"
        case .running:
            if isIndoorWorkout {
                title = "室內跑步"
                symbolName = "figure.run"
                
            } else {
                title = "室外跑步"
                symbolName = "figure.run"
            }
        case .sailing:
            title = "帆船"
            symbolName = "figure.sailing"
        case .skatingSports:
            title = "溜冰/滑板"
            symbolName = "figure.skating"
        case .snowSports:
            title = "雪地運動"
            symbolName = "snowflake"
        case .snowboarding:
            title = "滑雪板"
            symbolName = "figure.snowboarding"
        case .soccer:
            title = "足球"
            symbolName = "figure.soccer"
        case .socialDance:
            title = "社交舞"
            symbolName = "figure.socialdance"
        case .softball:
            title = "壘球"
            symbolName = "figure.softball"
        case .squash:
            title = "美式壁球"
            symbolName = "figure.squash"
        case .stairClimbing:
            title = "踏步機"
            symbolName = "figure.stair.stepper"
        case .stairs:
            title = "樓梯"
            symbolName = "figure.stairs"
        case .stepTraining:
            title = "階梯訓練"
            symbolName = "figure.step.training"
        case .surfingSports:
            title = "衝浪"
            symbolName = "figure.surfing"
//        case .swimBikeRun:
//            title = "壘球"
//            symbolName = "figure.squash" //v
        case .swimming:
            title = "游泳"
            symbolName = "figure.pool.swim"
        case .tableTennis:
            title = "桌球"
            symbolName = "figure.table.tennis"
        case .taiChi:
            title = "太極"
            symbolName = "figure.taichi"
        case .tennis:
            title = "網球"
            symbolName = "figure.tennis"
        case .trackAndField:
            title = "田徑"
            symbolName = "figure.track.and.field"
        case .traditionalStrengthTraining:
            title = "傳統肌力訓練"
            symbolName = "figure.strengthtraining.traditional"
        case .transition:
            title = "傳統肌力訓練"
            symbolName = "figure.strengthtraining.traditional" //v
        case .volleyball:
            title = "排球"
            symbolName = "figure.volleyball"
        case .walking:
            if isIndoorWorkout {
                title = "室內步行"
                symbolName = "figure.walk"
                
            } else {
                title = "室外步行"
                symbolName = "figure.walk"
            }
        case .waterFitness:
            title = "水中健身"
            symbolName = "figure.water.fitness"
        case .waterPolo:
            title = "水球"
            symbolName = "figure.waterpolo" //v
        case .waterSports:
            title = "水上運動"
            symbolName = "water.waves" //v
        case .wheelchairRunPace:
            title = "水上運動"
            symbolName = "figure.roll.runningpace"//v
        case .wheelchairWalkPace:
            title = "輪椅"
            symbolName = "figure.roll"
        case .wrestling:
            title = "角力"
            symbolName = "figure.wrestling"
        case .yoga:
            title = "瑜珈"
            symbolName = "figure.yoga"
        case .other:
            title = "其他"
            symbolName = "dumbbell.fill"
        
        default:
            title = "未知的運動類型"
            symbolName = "camera.metering.unknown"
        }
       
            // 获取热量消耗信息（如果有）
        if let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) {
            caloriesBurnedString = String(format: "%.0f 大卡", caloriesBurned)
        }
        
        let image = UIImage(systemName: symbolName)
        
       return (image, title, caloriesBurnedString)
    }

    func isIndoorWorkout(workout: HKWorkout) -> Bool {
        if let metadata = workout.metadata,
           let indoorValue = metadata[HKMetadataKeyIndoorWorkout] as? Bool {
            return indoorValue
        }
        return false // 默认为室外活动
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval) % 60
        let minutes = (Int(timeInterval) / 60) % 60
        let hours = (Int(timeInterval) / 3600)
        
        if hours <= 0 {
            return String(format: "%02d 分 %02d 秒", minutes, seconds)
        } else if minutes <= 0 {
            return String(format: "%02d 秒",  seconds)
        } else {
            return String(format: "%02d 時 %02d 分%02d 秒", hours, minutes, seconds)
        }
        
        
    }

    
}
