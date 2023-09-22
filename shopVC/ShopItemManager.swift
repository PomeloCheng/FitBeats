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
    let checkPointPrice: Int
    let heatPointPrice: Int
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
            print(querySnapshot?.documents)
            print("is in")
            var products: [fireBaseProduct] = []
            
            // 处理从 Firebase 获取的商品数据
            for document in querySnapshot!.documents {
                print("in")
                let productData = document.data()
                
                if let productName = productData["productsName"] as? String,
                   let productDescription = productData["intro"] as? String,
                   let imageURL = productData["image"] as? String,
                   let productsID = productData["productsID"] as? Int,
                   let productAmount = productData["amount"] as? Int,
                   let productCategories = productData["categoryIDs"] as? [Int],
                   let productCheckPrice = productData["checkPointPrice"] as? Int,
                   let productHeatPrice = productData["heatPointPrice"] as? Int {
                   let product = fireBaseProduct(productsID: productsID, productsName: productName, amount: productAmount, checkPointPrice: productCheckPrice, heatPointPrice: productHeatPrice, image: imageURL, categoryIDs: productCategories, intro: productDescription)
                    products.append(product)
                    print(product)
                }
            }
            completion(products)
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
