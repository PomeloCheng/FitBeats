//
//  infoViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/13.
//

import UIKit

class infoViewController: UIViewController {

    var isHomePresent = false
    @IBOutlet weak var closeMark: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "使用說明"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        closeMark.isHidden = isHomePresent ? false:true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeMark.isHidden = true
        isHomePresent = false
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
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
