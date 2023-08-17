//
//  itemModel.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/10.
//

import Foundation
import UIKit

typealias DoneHandler<T> = (T) -> Void
typealias imageDoneHandler = ( _ result: Data?) -> Void

struct Point: Codable {
    let checkPoint : Int
    let heatPoint : Int
    
}

struct History: Codable {
    let userID : Int
    let purchaseTime: String
    let productsName: String
    let purchaseQuantity: Int
    let checkPointPrice: Int
    let totalAmount: Int
    
    private enum CodingKeys: String, CodingKey {
        case userID,
             purchaseTime,
             productsName,
             purchaseQuantity,
             totalAmount,
             checkPointPrice
    }
}

struct Product: Codable {
    let productsID: Int
    let productsName: String
    let amount: Int
    let checkPointPrice: Int
    let heatPointPrice: Int
    let image : String?
    let categoryID: Int
    let intro: String
    
    private enum CodingKeys: String, CodingKey {
        case productsID,
             productsName,
             amount,
             checkPointPrice,
             heatPointPrice,
             image,
             categoryID,
             intro
    }
    
}

class Communicator {
    let getListURL = "fitbeatsData.php?categoryID="
    static let basicURL = "http://localhost:8888/FitBeats/"
    let userPhp = "user.php"
    let purchaseHistoryPhp = "purchaseHistory.php"
    let shearchHistoryPhp = "searchHistory.php?userID="
    let pointPHP = "point.php?userID="
    var NavC : UINavigationController? = nil
    
    static let shared = Communicator()
    private init() {}
    
   
    
    func uploadUser(username:String, phoneNumber:String, uuid: String, completion: @escaping (Bool) -> Void){
        let parameters = ["username": username, "phoneNumber": phoneNumber, "uuid": uuid]
        doPost(userPhp, parameters: parameters, completion: completion)
        
    }
    func uploadHistory(userID: Int, productsID: Int, purchaseQuantity: Int, completion: @escaping (Bool) -> Void){
        let parameters = ["userID": userID, "productsID": productsID, "purchaseQuantity": purchaseQuantity]
        doPost(purchaseHistoryPhp, parameters: parameters, completion: completion)
        
    }
    func getHistory(userID: Int,completion: @escaping DoneHandler<[History]>) {
    let targetURL = shearchHistoryPhp + "\(userID)"
       doGet(targetURL, responseType: [History].self, completion: completion)
    }
    func getList(categoryID: Int,completion: @escaping DoneHandler<[Product]>) {
    let targetURL = getListURL + "\(categoryID)"
       doGet(targetURL, responseType: [Product].self, completion: completion)
    }
    
    func getPoints(userID: Int,completion: @escaping DoneHandler<Point>) {
        let targetURL = pointPHP + "\(userID)"
           doGet(targetURL, responseType: Point.self, completion: completion)
    }
    func uploadPoints(userID: Int, newCheckPoint: Int, newHeatPoint: Int,completion: @escaping (Bool) -> Void) {
        let parameters : [String: Any] = ["userID": userID, "checkPoint": newCheckPoint, "heatPoint": newHeatPoint]
        let targetURL = pointPHP + "\(userID)"
        doPost(targetURL, parameters: parameters, completion: completion)
    }
    
    
    
    func doGet<T: Codable>(_ urlString: String, responseType: T.Type, completion: @escaping DoneHandler<T>) {
        // 構建您的 API 請求 URL
        guard let targetURL = URL(string: Communicator.basicURL + urlString) else {
            return
        }
        print("\(targetURL)")
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error  = error{
                print("Download fail: \(error)")
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse else{
                assertionFailure("Invalid data or response.")
                return
            }
            //練習方便，實際運用不需要
            if response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(result)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func downloadPhoto(fileURL: String, competion: @escaping imageDoneHandler){
        
        if let imageURL = URL(string: Communicator.basicURL + fileURL) {
            // 使用 imageURL 來載入圖片並設定到 UIImageView
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL){
                    competion(data)
                }
            }
        }
    }
    
    
    private func doPost(_ urlString: String, parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let finalurl = URL(string: Communicator.basicURL + urlString) else {
            return
        }
        print("\(finalurl)")
        var request = URLRequest(url: finalurl)
        request.httpMethod = "POST"
        
        
        do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error uploading data: \(error)")
                        completion(false)
                        return
                    }
                    
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                        if responseString.contains("successfully") {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
                task.resume()
            } catch {
                print("Error encoding user data: \(error)")
                completion(false)
            }
        
    }
}
