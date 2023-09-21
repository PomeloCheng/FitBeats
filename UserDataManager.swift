//
//  userData.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UserDataManager {
    
    static let shared = UserDataManager()
    var currentUserData: [String: Any]?
    var currentUserUid: String = ""
    var currentUserPhoneNumber: String?
    var uploadImageIndex = 0
    
    
    func checkUserExists(completion: @escaping(Bool) -> Void){
        if let userID = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let usersCollection = db.collection("Users")
            let userDocument = usersCollection.document(userID)
            currentUserUid = userID
            userDocument.getDocument { (document, error) in
                if let error = error {
                    print("Error checking user data: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    // 用户数据已存在，不需要再次创建
                    print("User data already exists.")
                    completion(true)
                } else {
                    print("User data created successfully.")
                    completion(false)
                }
            }
        }
    
    }
    
    func createUserInFirestore(phoneNumber: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        // 创建用户数据
        let userData: [String: Any] = [
            "name": "未填寫",
            "email": "未填寫", // 如果邮箱为空，可以设置为默认值
            "phoneNumber": phoneNumber,
            "profileImageURL": "", // 如果头像 URL 为空，可以设置为默认值
            "CheckinPoints": 0,
            "CaloriesPoints": 0
        ]
        
        currentUserData = userData
        
        // 将用户数据写入 Firestore
        usersCollection.document(currentUserUid).setData(userData) { error in
            if let error = error {
                print("Error creating user in Firestore: \(error.localizedDescription)")
            } else {
                
                print("User data created in Firestore successfully.")
            }
        }
    }
    
    func updateUserInfoInFirestore(fieldName: String, fieldValue: Any) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        // 创建包含要更新的字段的字典
        let updatedUserData: [String: Any] = [
            fieldName: fieldValue
        ]
       
        // 发送通知，通知其他地方用户信息已更新
        NotificationCenter.default.post(name: .userProfileDataUpdated, object: nil)
        
        // 更新 Firestore 中的用户数据
        usersCollection.document(currentUserUid).updateData(updatedUserData) { error in
            if let error = error {
                print("Error updating user info in Firestore: \(error.localizedDescription)")
            } else {
                print("User info updated in Firestore successfully.")
            }
        }
    }
    
    
    func fetchUserData() {
        
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("Users")
        
        usersCollection.document(currentUserUid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                if let userData = document.data() {
                    // 在此处处理 userData，它是一个包含文档字段的字典
                    print("User data retrieved from Firestore: \(userData)")
                    
                    // 更新 currentUserData
                    self.currentUserData = userData
                    let currentPhoneNumber = userData["phoneNumber"] as? String
                    self.currentUserPhoneNumber = currentPhoneNumber
                    // 发送通知，通知其他地方用户数据已更新
                    NotificationCenter.default.post(name: .userProfileDataUpdated, object: nil)
                } else {
                    print("Document data is empty.")
                }
            } else {
                print("Document does not exist.")
            }
        }
    }
    
    
    func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileImagesRef = storageRef.child("profile_images/\(currentUserUid).jpg")
        
        // 上传图片数据
        profileImagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(nil)
            } else {
                // 成功上传图片，获取下载URL
                profileImagesRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        let imageURLString = downloadURL.absoluteString
                        completion(imageURLString)
                        self.uploadImageIndex = 1
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func downloadProfileImage(imageURLString: String, completion: @escaping (Data?) -> Void) {
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
                    self.uploadImageIndex = 0
                    
                } else {
                    completion(nil)
                }
            }
        }
    }

}


extension Notification.Name {
    static let userProfileDataUpdated = Notification.Name("UserProfileDataUpdated")
    
}
