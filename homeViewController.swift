//
//  ViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import MKRingProgressView

class homeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let ringProgressView = RingProgressView(frame: CGRect(x: 180, y: 375, width: 200, height: 200))
        ringProgressView.startColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringProgressView.endColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
        ringProgressView.gradientImageScale = 0.5
        ringProgressView.ringWidth = 25
        ringProgressView.progress = 0.0
        ringProgressView.shadowOpacity = 0.0
        view.addSubview(ringProgressView)
        
        UIView.animate(withDuration: 0.5) {
            ringProgressView.progress = 1
        }
        
        
    }


}

