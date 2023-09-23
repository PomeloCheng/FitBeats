//
//  TradingRecordManager.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct TradingRecord {
    let productName: String
    let purchaseDetails: [String: Any]
    let redemptionDate: String
}


class TradingRecordManager {
    
    static let shared = TradingRecordManager()
    private init() {}
    
    func createOrUpdateRedemptionRecordAfterPurchase(productName: String, purchaseDetails: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated.")
            return
        }

        let db = Firestore.firestore()
        let redemptionRecordsCollection = db.collection("RedemptionRecords")

        // 步骤 1：尝试获取用户文档
        redemptionRecordsCollection.document(userID).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            guard let document = document else {
                completion(false)
                return
            }
                // 更新用户文档的逻辑，例如添加新的兑换记录子集合和文档
                self?.updateRedemptionRecord(document: document, productName: productName, purchaseDetails: purchaseDetails){ result in
                    if result {
                        completion(true)
                        
                    } else {
                        completion(false)
                    }
            }
        }
    }

    func updateRedemptionRecord(document: DocumentSnapshot, productName: String, purchaseDetails: [String: Any],  completion: @escaping (Bool) -> Void) {
        // 在此处更新用户文档和兑换记录
        // 与之前的示例代码类似，可以根据需要进行更新操作

        // 步骤 3：获取对子集合的引用
        let productSubcollectionRef = document.reference.collection("purchaseHistory")

        // 步骤 4：在子集合中创建一个新文档，包含兑换日期和时间以及其他相关信息
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)

        let redemptionRecordData: [String: Any] = [
            "productName": productName,
            "redemptionDate": dateString,
            "purchaseDetails": purchaseDetails  // 可根据需要添加其他信息
        ]

        // 步骤 5：将兑换记录信息添加到文档中
        productSubcollectionRef.addDocument(data: redemptionRecordData) { error in
            if let error = error {
                print("Error creating redemption record: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Redemption record created successfully.")
                completion(true)
            }
        }
    }
    

    
    func fetch(ID: String, completion: @escaping ([TradingRecord]?) -> Void) {
        
        let db = Firestore.firestore()
        let redemptionRecordsCollection = db.collection("RedemptionRecords")
        
        // 步骤 1：获取对用户兑换记录文档的引用
        let purchaseHistorySubcollectionRef = redemptionRecordsCollection.document(ID).collection("purchaseHistory")
        
        
        // 步骤 2：获取用户兑换记录文档中的所有子集合
        purchaseHistorySubcollectionRef.order(by: "redemptionDate", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching collections: \(error.localizedDescription)")
                completion(nil)
                return
            }
            var tradingRecords: [TradingRecord] = []
            
            // 步骤 3：遍历每个子集合
            for document in querySnapshot!.documents {
                let purchaseData = document.data()
                if let productName = purchaseData["productName"] as? String,
                   let redemptionDate = purchaseData["redemptionDate"] as? String,
                   let purchaseDetails = purchaseData["purchaseDetails"] as? [String: Any] {
                    let tradingRecord = TradingRecord(productName: productName, purchaseDetails: purchaseDetails, redemptionDate: redemptionDate)
                    tradingRecords.append(tradingRecord)
                }
            }
            
            // 完成后返回兑换记录数组
            completion(tradingRecords)
        }
    }

}
