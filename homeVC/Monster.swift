//
//  Monster.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/26.
//

import UIKit

class Monster {
    var level: Int
    var experience: Int
    var maxLevel: Int
    //var image: UIImage? // 如果您有图像属性的话
        
        init(level: Int, experience: Int, maxLevel: Int) {
            self.level = level
            self.experience = experience
            self.maxLevel = maxLevel
            //self.image = image
        }
    
    // 添加一个构造函数，从字典初始化 Monster 对象
        convenience init?(dictionary: [String: Any]) {
            guard let level = dictionary["level"] as? Int,
                  let experience = dictionary["experience"] as? Int,
                  let maxLevel = dictionary["maxLevel"] as? Int else {
                return nil
            }
            
            // 从字典中提取其他属性，如果有的话
            //let image = dictionary["image"] as? UIImage
            
            self.init(level: level, experience: experience, maxLevel: maxLevel)
        }
    
    
    func toDictionary() -> [String: Any] {
            let monsterData: [String: Any] = [
                "level": level,
                "experience": experience,
                "maxLevel": maxLevel
                // 将其他属性添加到字典中，如果有的话
            ]
            
//            if let image = image {
//                // 如果有图像，将其转换为 Data 或 URL，并存储在字典中
//                // 例如，将图像转换为 Data
//                if let imageData = image.pngData() {
//                    monsterData["imageData"] = imageData
//                }
//            }
            
            return monsterData
        }
}
