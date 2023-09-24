//
//  profileViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/13.
//

import UIKit

class profileViewController: UIViewController, UITextFieldDelegate {
    var maskView: UIView?
    var characterCountLabel : UILabel?
    var imagePicker: UIImagePickerController?
    let userData = UserDataManager.shared
    var messageTitle: String?
    var customAlertView: CustomAlertView?
    
        
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileBG: UIView!
    
    var currentName: String?
    var currentEmail: String?
    var currentImage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBG.layer.cornerRadius = 12
        profileBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        profileBG.layer.shadowColor = UIColor.lightGray.cgColor
        profileBG.layer.shadowOpacity = 0.2
        // Do any additional setup after loading the view.
        profileTable.dataSource = self
        profileTable.delegate = self
        
        // 添加点击手势识别器到 imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setData()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        maskView?.removeFromSuperview()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cameraBtnPressed(_ sender: Any) {
        imageViewTapped()
    }
}


extension profileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
        
         
        let currentPhoneNumber = userData.currentUserPhoneNumber
            switch indexPath.row {
            case 0:
                cell.profileLabel.text = "使用者名稱"
                cell.statusLabel.text = currentName
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.profileLabel.text = "E-Mail"
                cell.statusLabel.text = currentEmail
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.profileLabel.text = "手機號碼"
                cell.statusLabel.text = currentPhoneNumber
                cell.isUserInteractionEnabled = false
                cell.accessoryType = .none
            default:
                break
            }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            messageTitle = "編輯使用者名稱"
            setPopupText(messageTitle: messageTitle!)
        case 1:
            messageTitle = "編輯電子郵件"
            setPopupText(messageTitle: messageTitle!)
        
        default:
            break
        }
        
        }
        
    func setData() {
        if let name = userData.currentUserData?["name"] as? String,
           let email = userData.currentUserData?["email"] as? String,
           let imageURL = userData.currentUserData?["profileImageURL"] as? String {
            currentName = name
            currentEmail = email
            currentImage = imageURL
        }
        
        
        
        if currentImage != "" {
            if let image = logImage.shared.load(filename: self.userData.currentUserUid),
                userData.uploadImageIndex == 0 {
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
                print("* Load from cache: \(userData.currentUserUid)") //方便我們自己觀察真的從快取讀出來的
            } else {
                userData.downloadProfileImage(imageURLString: currentImage!) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    let orginImage = UIImage(data:imageData)
                    let newimage = orginImage!.resize(maxEdge: 200)
                    do {
                        try logImage.shared.save(data: imageData, filename: self.userData.currentUserUid)
                    } catch {
                        print("write File error : \(error) ")
                        //建議不要print，用alert秀出來比較方便
                    }
                    DispatchQueue.main.async {
                        self.profileImage.image = newimage
                    }
                }
            }
        } else {
            let originalimage = UIImage(named: "avatar.png")
            let image = originalimage?.resize(maxEdge: 200)
            self.profileImage.image = image
            
        }
        
        
        
        
    }
}
