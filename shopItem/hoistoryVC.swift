//
//  hoistoryVC.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/14.
//

import UIKit

class hoistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tradingRecords: [TradingRecord] = []
    @IBOutlet weak var hoistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        hoistoryTable.dataSource = self
        hoistoryTable.delegate = self
        
        let userID = UserDataManager.shared.currentUserUid
        TradingRecordManager.shared.fetch(ID: userID) { result in
            guard let result = result else {
                return
            }
            if !result.isEmpty {
                self.tradingRecords = result
                
                DispatchQueue.main.async {
                    self.hoistoryTable.reloadData()
                }
            }else{
                let label = UILabel()
                
                label.text = "尚未擁有兌換紀錄"
                label.textColor = .lightGray
                label.font = UIFont.systemFont(ofSize: 16)
                
                self.view.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    // 标题布局
                    label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    label.heightAnchor.constraint(equalToConstant: 40)])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tradingRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hoistoryTable.dequeueReusableCell(withIdentifier: "historyCell") as! historyTableViewCell
        let history = self.tradingRecords[indexPath.row]
        
        
        if let price = history.purchaseDetails["productPrice"] as? Int,
           let quantity = history.purchaseDetails["quantity"] as? Int,
           let totalPrice = history.purchaseDetails["finalPrice"] as? Int,
           let type = history.purchaseDetails["exchangeMethod"] as? String {
            cell.itemImage.image = logImage.shared.load(filename: history.productName)
            cell.name.text = history.productName
            cell.price.text = "\(price)"
            cell.amount.text = "x \(quantity)"
            cell.totalPrice.text = "總點數 \(totalPrice)"
            cell.time.text = history.redemptionDate
            
            cell.pointType.image = (type == "checkPoints" ? UIImage(named: "home_recommend_icon") : UIImage(named: "home_hot_icon"))
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none // 隱藏選取的背景
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
