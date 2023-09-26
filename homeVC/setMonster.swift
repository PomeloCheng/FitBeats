//
//  setMonster.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/26.
//

import UIKit


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
                    
                    self.lvLabel.text = String(format: "LV %d", currentMonster.level)
                    if currentMonster.level <= currentMonster.maxLevel {
                        self.setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                    }
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
        switch currentMonsterLevel {
        case 1:
            let requiredExperience = 10
            let experienceProgress =  Float(currentMonsterExperience) / Float(requiredExperience)
            self.experienceView.progress = experienceProgress
        case 2:
            let requiredExperience = 20
            let experienceProgress =  Float(currentMonsterExperience) / Float(requiredExperience)
            self.experienceView.progress = experienceProgress
        case 3:
            
            self.experienceView.progress = 1
        default:
            break
        }
    
    }
    func setEvolutionMonster(oldName: String, newName: String) {
        let newPetName = newName
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.petImagView.layer.opacity = 0.0
            }
            
            self.currentPetName.text = newPetName
            if let image = logImage.shared.load(filename: newPetName) {
                self.petImagView.image = image
            } else {
                ShopItemManager.shared.fetchProductURL(productName: newPetName) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    let orginImage = UIImage(data: imageData)
                    let newimage = orginImage!.resize(maxEdge: 200)
                    do {
                        try logImage.shared.save(data: imageData, filename: newPetName)
                    } catch {
                        print("write File error : \(error) ")
                        //建議不要print，用alert秀出來比較方便
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
        if var monster = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String:Any] {
            // 创建新的怪兽数据
            let newMonster = Monster(level: 1, experience: 0, maxLevel: 3)
            
            
            // 将新的怪兽数据添加到 ownedProducts 字典中
            monster[newPetName] = newMonster.toDictionary()
            
            
            UserDataManager.shared.currentUserData?["ownedHistory"] = monster
            
            // 从 ownedProducts 字典中移除怪兽
            monster.removeValue(forKey: oldName)

            // 更新用户数据中的 ownedProducts 字段
            UserDataManager.shared.currentUserData?["ownedProducts"] = monster
            UserDataManager.shared.currentUserData?["homePet"] = newPetName
            // 调用添加怪兽的方法
            UserDataManager.shared.updateUserInfoInFirestore(fieldName: "homePet", fieldValue: newPetName)
            UserDataManager.shared.addProductToOwnedProducts(monsterName: newPetName, monsterData: newMonster)
            UserDataManager.shared.deleteMonsterFromFirebase(withName: oldName)
        }
    
    }
    func evolution(name: String, currentMonsterLevel: Int, currentMonsterMaxLevel: Int) {
        switch name {
        case "普通蛋":
            if currentMonsterLevel == currentMonsterMaxLevel {
                setEvolutionMonster(oldName: name, newName: "小貓頭鷹")
            }
        case "小貓頭鷹":
            if currentMonsterLevel == currentMonsterMaxLevel {
                setEvolutionMonster(oldName: name, newName: "中貓頭鷹")
            }
        case "中貓頭鷹":
            if currentMonsterLevel == currentMonsterMaxLevel {
                setEvolutionMonster(oldName: name, newName: "大貓頭鷹")
            }
        default: break
        }
    }
    
    func increaseExperience() {
        if let petName = UserDataManager.shared.currentUserData?["homePet"] as? String,
           var monster = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String:Any],
           let currentMonsterData = monster[petName] as? [String:Any],
           let currentMonster = Monster(dictionary: currentMonsterData) {
            
            if currentMonster.level <= currentMonster.maxLevel {
                currentMonster.experience += 1
                switch currentMonster.level {
                case 1:
                    if currentMonster.experience >= 10 {
                        currentMonster.level += 1
                        currentMonster.experience = 0
                        lvLabel.text = String(format: "LV %d", currentMonster.level)
                        setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                        // 将新的怪兽数据添加到 ownedProducts 字典中
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        UserDataManager.shared.currentUserData?["ownedHistory"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        
                    } else {
                        setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                        // 将新的怪兽数据添加到 ownedProducts 字典中
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        UserDataManager.shared.currentUserData?["ownedHistory"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        
                    }
                case 2:
                    if currentMonster.experience >= 20 {
                        currentMonster.level += 1
                        currentMonster.experience = 0
                        lvLabel.text = String(format: "LV %d", currentMonster.level)
                        setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                        // 将新的怪兽数据添加到 ownedProducts 字典中
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        UserDataManager.shared.currentUserData?["ownedHistory"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        
                        
                    } else {
                        setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                        // 将新的怪兽数据添加到 ownedProducts 字典中
                        monster[petName] = currentMonster.toDictionary()
                        
                        // 更新用户数据中的 ownedProducts 字段
                        UserDataManager.shared.currentUserData?["ownedProducts"] = monster
                        UserDataManager.shared.currentUserData?["ownedHistory"] = monster
                        
                        // 调用添加怪兽的方法
                        UserDataManager.shared.addProductToOwnedProducts(monsterName: petName, monsterData: currentMonster)
                        
                    }
                case 3:
                    
                    lvLabel.text = String(format: "LV %d", currentMonster.level)
                    setProgressView(currentMonsterExperience: currentMonster.experience, currentMonsterLevel: currentMonster.level)
                   
                    evolution(name: petName, currentMonsterLevel: currentMonster.level, currentMonsterMaxLevel: currentMonster.maxLevel)
                    
                    
                default : break
                }
                
            }
        }
    }
}
