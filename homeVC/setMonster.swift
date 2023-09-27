//
//  setMonster.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/26.
//

import UIKit
import Lottie


extension homeViewController {
    
    
    func setHomeUserData(animate: Bool) {
        if let petName = UserDataManager.shared.currentUserData?["homePet"] as? String,
           let homeCheck = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int,
           let homeCaro = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int,
           let monster = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String:Any] {
            
            DispatchQueue.main.async {
                
                if animate {
                    UIView.animate(withDuration: 0.3) {
                        self.homeCheckLabel.layer.opacity = 0.0
                        self.homeCaroLabel.layer.opacity = 0.0
                        self.petImagView.layer.opacity = 0.0
                    }
                }
                self.currentPetName.text = petName
                self.homeCaroLabel.text = String(format: "%d", homeCaro)
                self.homeCheckLabel.text = String(format: "%d", homeCheck)
                
                if petName == "預設怪獸" {
                    self.petImagView.image = UIImage(named: "default_home.png")
                } else {
                    self.petImagView.image = logImage.shared.load(filename: petName)
                }
                
                if let currentMonsterData = monster[petName] as? [String:Any],
                   let currentMonster = Monster(dictionary: currentMonsterData) {
                    
                    self.lvLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
                    self.lvLabel.layer.shadowColor = UIColor.black.cgColor
                    self.lvLabel.layer.shadowOpacity = 1
                    self.lvLabel.clipsToBounds = false
                    self.lvLabel.text = String(format: "LV %d", currentMonster.level)
                    
//                    self.experienceView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
//                    self.experienceView.layer.shadowColor = UIColor.black.cgColor
//                    self.experienceView.layer.shadowOpacity = 0.5
//                    self.experienceView.clipsToBounds = false
                    self.experienceView.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 0.3)
                    self.experienceView.layer.borderWidth = 2
                    self.experienceView.backgroundColor = .white
                    self.experienceView.layer.cornerRadius = 4
                    self.setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                    
                    self.homePetExperienceLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
                    self.homePetExperienceLabel.layer.shadowColor = UIColor.black.cgColor
                    self.homePetExperienceLabel.layer.shadowOpacity = 1
                    self.homePetExperienceLabel.clipsToBounds = false
                    let requiredExperience = self.requiredExperienceForLevel(currentMonster.level)
                    self.homePetExperienceLabel.text = String(format: "(%d/%d)", currentMonster.experience,requiredExperience)
                    
                }
                
                if animate {
                    UIView.animate(withDuration: 0.1) {
                        self.homeCheckLabel.layer.opacity = 1.0
                        self.homeCaroLabel.layer.opacity = 1.0
                        self.petImagView.layer.opacity = 1.0
                    }
                }
            }
        }
    }
    
        func setProgressView(currentMonsterExperience: Int,currentMonsterLevel: Int) {
            let requiredExperience = requiredExperienceForLevel(currentMonsterLevel)
                let experienceProgress =  Float(currentMonsterExperience) / Float(requiredExperience)
                lvLabel.text = String(format: "LV %d", currentMonsterLevel)
                self.experienceView.progress = experienceProgress
            
    
        }
    func setEvolutionMonster(oldName: String, newName: String) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.petImagView.layer.opacity = 0.0
            }
            
            self.currentPetName.text = newName
            if let image = logImage.shared.load(filename: newName) {
                self.petImagView.image = image
            } else {
                ShopItemManager.shared.fetchProductURL(productName: newName) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    let orginImage = UIImage(data: imageData)
                    let newimage = orginImage!.resize(maxEdge: 200)
                    do {
                        try logImage.shared.save(data: imageData, filename: newName)
                    } catch {
                        print("write File error : \(error) ")
                        
                    }
                    self.petImagView.image = newimage
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.experienceView.progress = 0
                self.lvLabel.text = "LV 1"
                self.petImagView.layer.opacity = 1
            }
        }
        if var monster = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String:Any],
           var histotyMonster = UserDataManager.shared.currentUserData?["ownedHistory"] as? [String] {
            // 创建新的怪兽数据
            let newMonster = Monster(level: 1, experience: 0, maxLevel: 3)
            
            
            // 将新的怪兽数据添加到 ownedProducts 字典中
            monster[newName] = newMonster.toDictionary()
            histotyMonster.append(newName)
            
            UserDataManager.shared.currentUserData?["ownedHistory"] = histotyMonster
            
            // 从 ownedProducts 字典中移除怪兽
            monster.removeValue(forKey: oldName)
            
            // 更新用户数据中的 ownedProducts 字段
            UserDataManager.shared.currentUserData?["ownedProducts"] = monster
            UserDataManager.shared.currentUserData?["homePet"] = newName
            // 调用添加怪兽的方法
            UserDataManager.shared.updateUserInfoInFirestore(fieldName: "homePet", fieldValue: newName)
            UserDataManager.shared.addProductToOwnedProducts(monsterName: newName, monsterData: newMonster)
            UserDataManager.shared.deleteMonsterFromFirebase(withName: oldName)
        }
        
    }
    func evolution(name: String) {
        switch name {
        case "普通蛋":
            playAnimation()
                setEvolutionMonster(oldName: name, newName: "小貓頭鷹")
        case "小貓頭鷹":
            playAnimation()
                setEvolutionMonster(oldName: name, newName: "中貓頭鷹")
        case "中貓頭鷹":
            playAnimation()
                setEvolutionMonster(oldName: name, newName: "大貓頭鷹")
        default:
        
            break
            
        }
    }
    
    func increaseExperience() {
        if let petName = UserDataManager.shared.currentUserData?["homePet"] as? String,
           var monster = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String:Any],
           let currentMonsterData = monster[petName] as? [String:Any],
           let currentMonster = Monster(dictionary: currentMonsterData) {
            
            if currentMonster.level < currentMonster.maxLevel || (currentMonster.level == currentMonster.maxLevel && currentMonster.experience < requiredExperienceForLevel(currentMonster.level)) {
                // 继续增加经验值
                print("增加前：\(currentMonster.experience)")
                currentMonster.experience += 1
                print("增加後：\(currentMonster.experience)")
                let requiredExperience = requiredExperienceForLevel(currentMonster.level)
                let experienceProgress = Float(currentMonster.experience) / Float(requiredExperience)
                
                // 在主线程上更新进度视图
                DispatchQueue.main.async {
                    self.lvLabel.text = String(format: "LV %d", currentMonster.level)
                    self.experienceView.progress = experienceProgress
                    self.homePetExperienceLabel.text = String(format: "(%d/%d)", currentMonster.experience,requiredExperience)
                }
                
                // 如果经验值达到所需值，重置进度视图并升级怪兽
                if currentMonster.experience >= requiredExperience {
                    if currentMonster.level < currentMonster.maxLevel {
                        currentMonster.experience = 0
                        currentMonster.level += 1
                        print("如果经验值达到所需值，重置进度视图并升级怪兽後：\(currentMonster.experience)")
                        DispatchQueue.main.async {
                            self.lvLabel.text = String(format: "LV %d", currentMonster.level)
                            self.experienceView.progress = 0
                            self.homePetExperienceLabel.text = String(format: "(%d/%d)", currentMonster.experience,requiredExperience)
                        }
                        // 更新怪兽数据
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        
                    } else if currentMonster.level == currentMonster.maxLevel {
                        // 更新怪兽数据
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        // 先更新再進化
                        evolution(name: petName)
                    }
                } else {
                    //經驗值沒大於直接更新數據
                    // 更新怪兽数据
                    monster[petName] = currentMonster.toDictionary()
                    
                    // 更新用户数据中的 ownedProducts 字段
                    UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                    
                    // 调用添加怪兽的方法
                    UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                }
                
                
            } else {
                // 不要增加经验值
                DispatchQueue.main.async {
                    self.lvLabel.text = String(format: "LV %d", currentMonster.maxLevel)
                    self.experienceView.progress = 1
                    self.homePetExperienceLabel.text = String(format: "(%d/%d)", currentMonster.experience,currentMonster.experience)
                }
            }
            
        }
    }
    
    func requiredExperienceForLevel(_ level: Int) -> Int {
        switch level {
        case 1:
            return 10
        case 2:
            return 15
        case 3:
            return 20
        default:
            return 0
        }
    }
    
    func playAnimation() {
        let anim = LottieAnimation.named("evlotion_animate.json")
        self.evlotionAnimate.animation = anim
        self.evlotionAnimate.contentMode = .scaleAspectFill
        self.evlotionAnimate.backgroundColor = .clear
        self.evlotionAnimate.play()
    }
}
