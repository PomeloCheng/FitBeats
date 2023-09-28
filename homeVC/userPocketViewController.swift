//
//  userPocketViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/24.
//

import UIKit
class userPocketViewController: UIViewController {
    
    var maskView : UIView?
    
    @IBOutlet weak var userPocketCollectView: UICollectionView!
    var userPcoket: [String] = []
    
    var selectPet: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        userPocketCollectView.dataSource = self
        userPocketCollectView.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let currentPocket = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String: Any] {
            // currentPocket 是一个字典，其中键是怪兽名称，值是怪兽的属性字典
            // 如果您只需要怪兽名称，您可以通过获取字典的键来获取它们
            let monsterNames = Array(currentPocket.keys)
            
            // 将怪兽名称存储在 userPcoket 中
            self.userPcoket = monsterNames
            DispatchQueue.main.async {
                self.userPocketCollectView.reloadData()
            }
        }
       
    }
    
    @IBAction func closeMarkBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
extension userPocketViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPcoket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPocket", for: indexPath) as! userPocketViewCell
        let userPocketPet = userPcoket[indexPath.row]
        if userPocketPet == "小圓貓" {
            cell.userOwenPetImage.image = UIImage(named: "default_home.png")
        } else {
            if let image = logImage.shared.load(filename: userPocketPet) {
               DispatchQueue.main.async {
                   cell.userOwenPetImage.image = image
               }
            
            } else {
                ShopItemManager.shared.fetchProductURL(productName: userPocketPet) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    let orginImage = UIImage(data: imageData)
                    let newimage = orginImage!.resize(maxEdge: 200)
                    do {
                        try logImage.shared.save(data: imageData, filename: userPocketPet)
                    } catch {
                        print("write File error : \(error) ")
                        //建議不要print，用alert秀出來比較方便
                    }
                    DispatchQueue.main.async {
                        cell.userOwenPetImage.image = newimage
                    }
                }
            }
        }
        cell.userOwenPetName.text = userPocketPet
        
        if let pocketMonsterData = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String: Any],
              let currentMonsterData = pocketMonsterData[userPocketPet] as? [String:Any],
              let currentMonster = Monster(dictionary: currentMonsterData) {
            
            let requiredExperience = requiredExperienceForLevel(currentMonster.level)
            cell.userExperienceLabel.text = String(format: "(%d/%d)", currentMonster.experience, requiredExperience)
            let experienceProgress =  Float(currentMonster.experience) / Float(requiredExperience)
            cell.userExperienceProgress.progress = experienceProgress
            if currentMonster.level == currentMonster.maxLevel {
                cell.userOwenPetLevel.text = "MAX"
            } else {
                cell.userOwenPetLevel.text = String(format: "LV %d", currentMonster.level)
            }
        }
        
        
        
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.backgroundColor = .clear
        cell.bgView.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        cell.bgView.layer.borderWidth = 3
        cell.bgView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.bgView.layer.shadowColor = UIColor.white.cgColor
        cell.bgView.layer.shadowOpacity = 0.2
        
        cell.backgroundView = UIImageView(image: UIImage(named: "cardBg.png"))
        cell.backgroundView?.layer.cornerRadius = 10
        cell.backgroundView?.clipsToBounds = true
        cell.backgroundView?.layer.opacity = 0.1
        
            // 设置图像的显示方式（这里使用了 .scaleAspectFill，您可以根据需要选择其他模式）
            cell.backgroundView?.contentMode = .scaleAspectFill
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width
        let itemWidth = screenWidth / 2 - 36// 每一列顯示兩個項目
        let itemHeight: CGFloat = 200 // 設定固定的高度
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectPet = userPcoket[indexPath.row]
        
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let alert = popAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 192))
        alert.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alert.cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 15
        alert.messageLabel.text = "選擇後將會更換您的首頁怪獸"
        alert.setOKBtn(isShow: false)
        
        alert.center = view.center
        maskView.addSubview(alert)
        self.view.addSubview(maskView)
        
        
        
        
        
        
        
    }
    
    @objc func cancelButtonTapped() {
        maskView?.removeFromSuperview()
    }
    
    @objc func okButtonTapped() {
        UserDataManager.shared.currentUserData?["homePet"] = selectPet
        UserDataManager.shared.updateUserInfoInFirestore(fieldName: "homePet", fieldValue: selectPet!)
        
        NotificationCenter.default.post(name: .userProfileFetched, object: nil)
        maskView?.removeFromSuperview()
        self.dismiss(animated: true)
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
    
}

