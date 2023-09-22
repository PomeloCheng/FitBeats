//
//  itemViewController.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/11.
//

import UIKit
protocol updateMoneyDelegate:AnyObject {
    func updateMoney()
}

class itemViewController: UIViewController {
    
    
    @IBOutlet weak var intro: UILabel!
    @IBOutlet weak var shopStackView: UIStackView!
    var fireProducts: fireBaseProduct!
    var product: Product!
    var finalAmount = 1
    var purchaseAmount = 0
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var amountTextView: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    weak var updateMoneyDelegate : updateMoneyDelegate?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 在進入內頁時顯示導航欄
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavBar(nav: self.navigationItem)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        name.text = fireProducts.productsName
        price.text = String(fireProducts.checkPointPrice)
        itemImage.image = logImage.shared.load(filename: fireProducts.productsName)
        amountTextView.text = "1"
        purchaseAmount = finalAmount * fireProducts.checkPointPrice
        finalPrice.text = "總金額$ \(purchaseAmount)"
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
        purchaseAmount = finalAmount * fireProducts.checkPointPrice
        finalPrice.text = "總金額$ \(purchaseAmount)"
        
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
        purchaseAmount = finalAmount * product.checkPointPrice
        finalPrice.text = "總金額$ \(purchaseAmount)"
    }
    
    @IBAction func buyBtnPressed(_ sender: Any) {
        if checkPoint >= purchaseAmount {
            Communicator.shared.uploadHistory(userID: userID, productsID: product.productsID, purchaseQuantity: finalAmount) { result in
                switch result {
                case true:
                    DispatchQueue.main.async { [self] in
                        checkPoint -= purchaseAmount
                        alert(message: "購買成功！")
                       
                        self.updateMoneyDelegate?.updateMoney()
                    }
                    print("upload Success.")
                case false:
                    print("error.")
                }
            }
        }else{
            alert(message: "錢不夠喔！")
        }
    }
    
    func alert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle:.alert)
        let OK = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        
        if message == "錢不夠喔！"{
            let OK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OK)
        } else if message != "購買成功！" {
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(OK)
            alert.addAction(cancel)
        }else{
            alert.addAction(OK)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // 重新顯示 tabBarController
            tabBarController?.tabBar.isHidden = false
       
        }
    
}

func setNavBar(nav:UINavigationItem) {
    
    // 創建自定義的UIView，包含圖片和Label
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
    
    let imageView = UIImageView(image: UIImage(named: "home_recommend_icon.png"))
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    
    let label = UILabel(frame: CGRect(x: 40, y: 0, width: 80, height: 40))
    label.text = "\(checkPoint)"
    label.textColor = .black
    
    customView.addSubview(imageView)
    customView.addSubview(label)
    
    // 創建自定義的UIBarButtonItem
    let customBarButtonItem = UIBarButtonItem(customView: customView)
    
    // 設置自定義的BarButtonItem為左邊的NavigationBar項目
    nav.rightBarButtonItem = customBarButtonItem
}

