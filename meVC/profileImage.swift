//
//  profileImage.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/14.
//

import UIKit

extension profileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func imageViewTapped(){
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let shadowView = UIView(frame: CGRect(x: profileImage.center.x, y: profileImage.center.y, width: 150, height: 140))
           
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 10
        
        // 創建一個自定義的UIView，模擬警告框的效果
        let customAlertView = CustomOptionsView(frame: shadowView.bounds)
        customAlertView.backgroundColor = .clear
        customAlertView.layer.cornerRadius = 10
        customAlertView.clipsToBounds = true
        shadowView.addSubview(customAlertView)
        customAlertView.albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        customAlertView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        // 將自定義的UIView添加到遮罩視圖上
        maskView.addSubview(shadowView)
        self.view.addSubview(maskView)
    
    }
    
    @objc func albumButtonTapped(){
        imagePicker!.sourceType = .photoLibrary
        self.present(imagePicker!, animated: true, completion: nil)
        maskView?.removeFromSuperview()
    }
    
    @objc func cameraButtonTapped(){
        imagePicker!.sourceType = .camera
        self.present(imagePicker!, animated: true, completion: nil)
        maskView?.removeFromSuperview()
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalimage = info[.originalImage] as? UIImage,
            let image = originalimage.resize(maxEdge: 120) else {
            assertionFailure("Invalid UIImage")
            return
        }
        self.profileImage.image = image
        self.profileImage.layer.cornerRadius = 60
        self.profileImage.contentMode = .scaleAspectFill
        
        
        userData.uploadProfileImage(image: image) { imageURLString in
                if let imageURLString = imageURLString {
                    // 图片上传成功，您可以在此处将 imageURLString 存储到用户数据中
                    // 然后更新用户数据到 Firestore
                    self.userData.currentUserData?["profileImageURL"] = imageURLString
                    UserDataManager.shared.updateUserInfoInFirestore(fieldName: "profileImageURL", fieldValue: imageURLString)
                } else {
                    print("Failed to upload profile image.")
                }
            }
        
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
