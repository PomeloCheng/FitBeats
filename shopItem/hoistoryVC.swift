//
//  hoistoryVC.swift
//  textPHP
//
//  Created by YuCheng on 2023/8/14.
//

import UIKit

class hoistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var histories: [History] = []

    @IBOutlet weak var hoistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hoistoryTable.dataSource = self
        hoistoryTable.delegate = self
        Communicator.shared.getHistory(userID: 3) { result in
            if !result.isEmpty {
                self.histories = result
                DispatchQueue.main.async {
                    self.hoistoryTable.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hoistoryTable.dequeueReusableCell(withIdentifier: "historyCell") as! historyTableViewCell
        let history = self.histories[indexPath.row]
        cell.itemImage.image = logImage.shared.load(filename: history.productsName)
        cell.name.text = history.productsName
        cell.price.text = "$ \(Int(history.checkPointPrice))"
        cell.amount.text = "x \(history.purchaseQuantity)"
        cell.totalPrice.text = "總金額 $ \(Int(history.totalAmount))"
        cell.time.text = "\(history.purchaseTime)"
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
