//
//  ViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import MKRingProgressView

class homeViewController: UIViewController {

    @IBOutlet weak var ringProgressView: RingProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let ringProgressView = RingProgressView(frame: CGRect(x: 180, y: 500, width: 200, height: 200))
        ringProgressView.startColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringProgressView.endColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringProgressView.gradientImageScale = 0.5
        ringProgressView.ringWidth = 25
        ringProgressView.progress = 0.0
        ringProgressView.shadowOpacity = 0.0
        view.addSubview(ringProgressView)
        
        
        
    }

    
    @IBAction func testBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            self.ringProgressView.progress = 1.0
        }
    }
    
}

