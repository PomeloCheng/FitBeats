//
//  meViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/1.
//

import UIKit
import SafariServices
import FirebaseAuth

class meViewController: UIViewController {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var tableViewBG: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var currencyBG: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    var maskView: UIView?
    let userData = UserDataManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        currencyBG.layer.cornerRadius = 12
        currencyBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        currencyBG.layer.shadowColor = UIColor.lightGray.cgColor
        currencyBG.layer.shadowOpacity = 0.2
        
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        logoutBtn.layer.shadowColor = UIColor.lightGray.cgColor
        logoutBtn.layer.shadowOpacity = 0.2
        
        tableViewBG.layer.cornerRadius = 12
        tableViewBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        tableViewBG.layer.shadowColor = UIColor.lightGray.cgColor
        tableViewBG.layer.shadowOpacity = 0.2
        // Do any additional setup after loading the view.
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        profileImage.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        profileImage.layer.borderWidth = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        setImage()
        if let name = userData.currentUserData?["name"] as? String,
           let checkPoint = userData.currentUserData?["CheckinPoints"] as? Int,
           let caroPoint = userData.currentUserData?["CaloriesPoints"] as? Int {
            userName.text = name
            
            checkLabel.text = String(format: "%d", checkPoint)
            caroLabel.text = String(format: "%d", caroPoint)
        }
    }
    
    
    @objc func imageViewTapped() {
        setVC(VCName: "profileViewController")
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutBtnPressed(_ sender: Any) {
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let alert = popAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 212))
        alert.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alert.cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 15
        alert.messageLabel.text = "確定要登出？\n登出會返回初始手機登入畫面"
        alert.setOKBtn(isShow: false)
        
        alert.center = view.center
        maskView.addSubview(alert)
        self.view.addSubview(maskView)
        
        
    }
    
    @objc func cancelButtonTapped() {
        maskView?.removeFromSuperview()
    }
    
    @objc func okButtonTapped() {
        maskView?.removeFromSuperview()
            do {
                try Auth.auth().signOut()
                // 用户已成功登出
                
                var initialViewController: UIViewController
                // 返回到 PhoneViewController
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                if let phoneViewController = storyboard.instantiateViewController(withIdentifier: "PhoneViewController") as? PhoneViewController {
                initialViewController = UINavigationController(rootViewController: phoneViewController)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                    }
            } catch let signOutError as NSError {
                print("登出错误: %@", signOutError)
            }
    }
}

extension meViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! settingViewCell
        
        
        switch indexPath.row {
        case 0:
            cell.settingIcon.image = UIImage(systemName: "gearshape.fill")
            cell.settingLabel.text = "個人檔案"
        case 1:
            cell.settingIcon.image = UIImage(systemName: "info.circle.fill")
            cell.settingLabel.text = "使用說明"
        case 2:
            cell.settingIcon.image = UIImage(systemName: "books.vertical.fill")
            cell.settingLabel.text = "服務條款與隱私政策"
        case 3:
            cell.settingIcon.image = UIImage(systemName: "book.closed.fill")
            cell.settingLabel.text = "怪獸圖鑑"
        default:
            cell.settingIcon.image = UIImage(systemName: "ellipsis.circle.fill")
            cell.settingLabel.text = "預設"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
            setVC(VCName: "profileViewController")
            case 1:
            setVC(VCName: "infoViewController")
            case 2:
            setVC(VCName: "Privacy")
            case 3:
            setVC(VCName: "handbookViewController")
            default:
                break
            }
        
    }
    
    func setVC(VCName: String){
        let storyboard = UIStoryboard(name: "me", bundle: .main)
        var nextVC: UIViewController
        switch VCName {
            
        case "profileViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! profileViewController
            navigationController?.pushViewController(nextVC, animated: true)
        case "infoViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! infoViewController
            navigationController?.pushViewController(nextVC, animated: true)
        case "Privacy":
            if let url = URL(string: "https://www.privacypolicies.com/live/0907b983-940a-47d5-adf2-7c06c6baf582") {
                    let safariViewController = SFSafariViewController(url: url)
                    present(safariViewController, animated: true, completion: nil)
                }
        case "handbookViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! handbookViewController
            navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
        
    }
    
    
    func setImage() {
        
        guard let imageURL = userData.currentUserData?["profileImageURL"] as? String else {
            return
        }
        
                
        
        if imageURL != "" {
            if let image = logImage.shared.load(filename: self.userData.currentUserUid),
               userData.uploadImageIndex == 0 {
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
                print("* Load from cache: \(userData.currentUserUid)") //方便我們自己觀察真的從快取讀出來的
            } else {
                userData.downloadProfileImage(imageURLString: imageURL) { imageData in
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
