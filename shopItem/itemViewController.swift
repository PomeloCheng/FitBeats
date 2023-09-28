//
//  itemViewController.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/11.
//

import UIKit

class itemViewController: UIViewController {
    
    
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var currencyIcon: UIImageView!
    @IBOutlet weak var intro: UILabel!
    @IBOutlet weak var shopStackView: UIStackView!
    var fireProducts: fireBaseProduct!
    var finalAmount = 1
    var purchaseAmount = 0
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    var userCurrency: Int?
    var purchCurrenct: Int?
    var categoryTag: Int?
    var currencyLabel: UILabel?
    
    var maskView: UIView?
    
    override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                
                // 重新顯示 tabBarController
                tabBarController?.tabBar.isHidden = false
           
            }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let categoryTag = categoryTag else {
            return
        }
        // 在進入內頁時顯示導航欄
        navigationController?.setNavigationBarHidden(false, animated: true)
        if categoryTag == 4 {
            userCurrency =  UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int
        }
        else {
            userCurrency =  UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int
        }
        
        if let currentPocket = UserDataManager.shared.currentUserData?["ownedHistory"] as? [String] {
            // currentPocket 是一个字典，其中键是怪兽名称，值是怪兽的属性字典
            // 如果您只需要怪兽名称，您可以通过获取字典的键来获取它们
            
            if currentPocket.contains(self.fireProducts.productName) {
                DispatchQueue.main.async {
                    
                    self.changeBtn.isEnabled = false
                    self.changeBtn.backgroundColor = .systemGray6
                    self.finalPrice.text = "已擁有"
                }
            } else {
                DispatchQueue.main.async {
                    
                    self.changeBtn.isEnabled = true
                    self.changeBtn.backgroundColor = UIColor.tintColor
                    self.finalPrice.text = "購買將花費您 \(self.purchaseAmount) 點"
                }
            }
            
        }
        
        setNavBar(nav: self.navigationItem)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
            if categoryTag == 4 {
                currencyIcon.image = UIImage(named: "home_recommend_icon.png")
                purchCurrenct = fireProducts.checkinPoints
            }
            else {
                currencyIcon.image = UIImage(named: "home_hot_icon.png")
                purchCurrenct = fireProducts.caloriesPoints
            }
        
        purchaseAmount = finalAmount * purchCurrenct!
        name.text = fireProducts.productName
        price.text = String(fireProducts.checkinPoints)
        itemImage.image = logImage.shared.load(filename: fireProducts.productName)
        amountTextView.text = "1"
        
        intro.text = fireProducts.intro
        // Do any additional setup after loading the view.
        
        
        
        
    }
    

    
    @IBAction func addAmount(_ sender: Any) {
        if let currentNumber = Int(amountTextView.text!){
            var shopNumber = currentNumber
            shopNumber += 1
            amountTextView.text = "\(shopNumber)"
            finalAmount = shopNumber
        }
        purchaseAmount = finalAmount * purchCurrenct!
        finalPrice.text = "購買將花費您 \(purchaseAmount) 點"
        
    }
    
    @IBAction func minusAmount(_ sender: Any) {
        if let currentNumber = Int(amountTextView.text!){
            var shopNumber = currentNumber
            if shopNumber - 1 == 0 {
                alert(message: "您確定要移除商品？")
                
            }
            else {
                shopNumber -= 1
                amountTextView.text = "\(shopNumber)"
                finalAmount = shopNumber
            }
            
        }
        purchaseAmount = finalAmount * purchCurrenct!
        finalPrice.text = "購買將花費您 \(purchaseAmount) 點"
    }
    
    @IBAction func buyBtnPressed(_ sender: Any) {
        
        
        if userCurrency! >= purchaseAmount {
            alert(message: "確定要購買嗎？\n按下確認後會扣除相應的點數。")
        }else{
            alert(message: "錢不夠喔！\n請注意您的點數是否足夠。")
        }
    }
    
    func alert(message: String){
        
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let alert = popAlertView()
       
        if message == "購買成功！" {
            alert.frame = CGRect(x: 0, y: 0, width: 300, height: 192)
            alert.cancleButton.isHidden = true
            alert.setOKBtn(isShow: true)
            
            alert.okButton.addTarget(self, action: #selector(okBuyButtonTapped), for: .touchUpInside)
        } else if message == "錢不夠喔！\n請注意您的點數是否足夠。" {
            alert.frame = CGRect(x: 0, y: 0, width: 300, height: 212)
            alert.cancleButton.isHidden = true
            alert.setOKBtn(isShow: true)
            
            alert.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        } else {
            alert.frame = CGRect(x: 0, y: 0, width: 300, height: 212)
            alert.cancleButton.isHidden = false
            alert.setOKBtn(isShow: false)
            
            alert.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        }
        
        alert.cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 15
        alert.messageLabel.text = message
        
        alert.center = view.center
        maskView.addSubview(alert)
        self.view.addSubview(maskView)
        currencyLabel?.textColor = UIColor.white
    }
    
    @objc func cancelButtonTapped() {
        maskView?.removeFromSuperview()
        currencyLabel?.textColor = UIColor.black
        
    }
    
    @objc func okBuyButtonTapped() {
        maskView?.removeFromSuperview()
        currencyLabel?.textColor = UIColor.black
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func okButtonTapped() {
        
        if userCurrency! >= purchaseAmount {
            var purchaseDetails: [String: Any]
                purchaseDetails = [
                    "exchangeMethod": "",
                    "productPrice": 0,
                    "exchangePrice": purchaseAmount,
                    "quantity": finalAmount,
                    "finalPrice": purchaseAmount
                ]
                
                if categoryTag == 4 {
                    purchaseDetails["exchangeMethod"] = "checkPoints"
                    purchaseDetails["productPrice"] = fireProducts.checkinPoints
                } else {
                    purchaseDetails["exchangeMethod"] = "caloriesPoints"
                    purchaseDetails["productPrice"] = fireProducts.caloriesPoints
                }
                
                
                TradingRecordManager.shared.createOrUpdateRedemptionRecordAfterPurchase(productName: fireProducts.productName, purchaseDetails: purchaseDetails){ result in
                    
                    if result {
                        let updateCurrency = self.userCurrency! - self.purchaseAmount
                        
                        ShopItemManager.shared.updateProducts(productName: self.fireProducts.productName, purchQuantity: self.finalAmount)
                        
                        if var ownedProducts = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String: Any],
                        var historyProducts = UserDataManager.shared.currentUserData?["ownedHistory"] as? [String] {
                            // 获取要购买的怪兽的名称
                            let monsterName = self.fireProducts.productName
                            
                            // 创建新的怪兽数据
                            let newMonster = Monster(level: 1, experience: 0, maxLevel: 3)
                             
                            historyProducts.append(monsterName)
                            // 将新的怪兽数据添加到 ownedProducts 字典中
                            ownedProducts[monsterName] = newMonster.toDictionary()
                            
                            // 更新用户数据中的 ownedProducts 字段
                            UserDataManager.shared.currentUserData?["ownedProducts"] = ownedProducts
                            UserDataManager.shared.currentUserData?["ownedHistory"] = historyProducts
                            
                            // 调用添加怪兽的方法
                            UserDataManager.shared.addProductToOwnedProducts(monsterName: monsterName, monsterData: newMonster)
                        }
                        
                        if purchaseDetails["exchangeMethod"] as! String == "checkPoints" {
                            UserDataManager.shared.currentUserData?["CheckinPoints"] = updateCurrency
                            UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CheckinPoints", fieldValue: updateCurrency)
                            
                            DispatchQueue.main.async {
                                
                                if let customLabel = self.currencyLabel {
                                    customLabel.text = String(format: "%d", updateCurrency)
                                    self.changeBtn.isEnabled = false
                                    self.changeBtn.backgroundColor = .systemGray6
                                    self.finalPrice.text = "已擁有"
                                    self.alert(message: "購買成功！")
                                }
                            }
                       
                        } else {
                            UserDataManager.shared.currentUserData?["CaloriesPoints"] = updateCurrency
                            UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CaloriesPoints", fieldValue: updateCurrency)
                            
                            DispatchQueue.main.async {
                                
                                if let customLabel = self.currencyLabel {
                                    customLabel.text = String(format: "%d", updateCurrency)
                                    self.changeBtn.isEnabled = false
                                    self.changeBtn.backgroundColor = .systemGray6
                                    self.finalPrice.text = "已擁有"
                                    self.alert(message: "購買成功！")
                                }
                            }
                        }
                        
                    }
                }
                
            maskView?.removeFromSuperview()
            currencyLabel?.textColor = UIColor.black
        }else{
            maskView?.removeFromSuperview()
            currencyLabel?.textColor = UIColor.black
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setNavBar(nav:UINavigationItem) {
        
        // 創建自定義的UIView，包含圖片和Label
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        var imageView:UIImageView
        if categoryTag == 4 {
            imageView = UIImageView(image: UIImage(named: "home_recommend_icon.png"))
        } else {
            imageView = UIImageView(image: UIImage(named: "home_hot_icon"))
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        currencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        
        guard let currencyLabel = currencyLabel else {
            return
        }
        
        if let userCurrency = userCurrency {
            currencyLabel.text = String(format: "%d", userCurrency)
        } else {
            currencyLabel.text = "未知"
        }
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 15)
        currencyLabel.textColor = .black
        
        customView.addSubview(imageView)
        customView.addSubview(currencyLabel)
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 标题布局
            currencyLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            currencyLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -8),
            imageView.rightAnchor.constraint(equalTo: currencyLabel.leftAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20)])
        // 創建自定義的UIBarButtonItem
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        
        // 設置自定義的BarButtonItem為左邊的NavigationBar項目
        nav.rightBarButtonItem = customBarButtonItem
        
    }
    
}




