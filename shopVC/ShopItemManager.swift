//
//  ShopItemManager.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct fireBaseProduct {
    let productsID: Int
    let productsName: String
    let amount: Int
    let checkinPoints: Int
    let caloriesPoints: Int
    let image : String?
    let categoryIDs: [Int]
    let intro: String
}
class ShopItemManager {
    static let shared = ShopItemManager()
    private init() {}
    
    func fetchProductData(categoryID: Int, completion: @escaping ([fireBaseProduct]?) -> Void) {
        let db = Firestore.firestore()
        let productsCollection = db.collection("Products")
        
        productsCollection.whereField("categoryIDs", arrayContains: categoryID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                completion(nil)
                return
            }
           
            var products: [fireBaseProduct] = []
            
            // 处理从 Firebase 获取的商品数据
            for document in querySnapshot!.documents {
                
                let productData = document.data()
                
                if let productName = productData["productsName"] as? String,
                   let productDescription = productData["intro"] as? String,
                   let imageURL = productData["image"] as? String,
                   let productsID = productData["productsID"] as? Int,
                   let productAmount = productData["amount"] as? Int,
                   let productCategories = productData["categoryIDs"] as? [Int],
                   let productCheckPrice = productData["checkinPoints"] as? Int,
                   let productHeatPrice = productData["caloriesPoints"] as? Int {
                   let product = fireBaseProduct(productsID: productsID, productsName: productName, amount: productAmount, checkinPoints: productCheckPrice, caloriesPoints: productHeatPrice, image: imageURL, categoryIDs: productCategories, intro: productDescription)
                    products.append(product)
                    
                }
            }
            completion(products)
        }
    }
    func updateProducts(productName: String, purchQuantity: Int) {
        let db = Firestore.firestore()
        let productsCollection = db.collection("Products")
        
        productsCollection.whereField("productsName", isEqualTo: productName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
                return
            }
            
            // 确保查询返回了至少一个文档
            guard let document = querySnapshot?.documents.first else {
                print("Product not found.")
                return
            }
            var productData = document.data()
            if let currentQuantity = productData["amount"] as? Int {
                // 步骤 3：更新数量
                let updatedQuantity = currentQuantity - purchQuantity
                if updatedQuantity >= 0 {
                    productData["amount"] = updatedQuantity // 更新数量字段
                } else {
                    print("Insufficient quantity available.")
                    return
                }
                // 步骤 4：将更新后的数据写回数据库
                productsCollection.document(document.documentID).setData(productData) { error in
                    if let error = error {
                        print("Error updating product quantity: \(error.localizedDescription)")
                    } else {
                        print("Product quantity updated successfully.")
                    }
                }
            }
        }
            
    }
    
    func downloadProductsImage(imageURLString: String, completion: @escaping (Data?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: imageURLString)
        
        // 下载图片数据
        storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading profile image: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let imageData = data {
                    completion(imageData)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
}
