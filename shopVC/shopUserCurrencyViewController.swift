//
//  shopUserCurrencyViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/23.
//

import UIKit

class shopUserCurrencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
