//
//  shopUserCurrencyViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/23.
//

import UIKit

class shopUserCurrencyViewController: UIViewController {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // "CheckinPoints": 0, "CaloriesPoints": 0
    
    override func viewWillAppear(_ animated: Bool) {
        if let checkPoint = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int,
           let caroPoint = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
            checkLabel.text = String(format: "%d", checkPoint)
            caroLabel.text = String(format: "%d", caroPoint)
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        
        tabBarController?.tabBar.isHidden = true
        if let hoistoryVC = storyboard?.instantiateViewController(withIdentifier: "hoistoryVC") as? hoistoryVC {
           
            navigationController?.pushViewController(hoistoryVC, animated: true)
            
            //topConstrant.constant = .zero
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

}
