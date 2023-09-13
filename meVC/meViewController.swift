//
//  meViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/1.
//

import UIKit

class meViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var currencyBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currencyBG.layer.cornerRadius = 18
        
        currencyBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        currencyBG.layer.shadowColor = UIColor.lightGray.cgColor
        currencyBG.layer.shadowOpacity = 0.2
        
        logoutBtn.layer.cornerRadius = 5
        
        logoutBtn.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        logoutBtn.layer.shadowColor = UIColor.lightGray.cgColor
        logoutBtn.layer.shadowOpacity = 0.2
        // Do any additional setup after loading the view.
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
