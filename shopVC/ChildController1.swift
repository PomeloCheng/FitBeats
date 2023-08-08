//
//  ChildController1.swift
//  XMLtest
//
//  Created by YuCheng on 2023/8/7.
//

import UIKit
import XLPagerTabStrip


class ChildController1: UIViewController,IndicatorInfoProvider,UIScrollViewDelegate {
    
    @IBOutlet weak var shopScrollView: UIScrollView!
    var identifier: String = ""

    
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        switch identifier {
        case "Child1":
            return IndicatorInfo(title: "Item One")
        case "Child2":
            return IndicatorInfo(title: "Item Two")
        
        default:
            return IndicatorInfo(title: "")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        shopScrollView.delegate = self
        switch identifier {
        case "Child1":
            self.view.backgroundColor = .blue
        case "Child2":
            self.view.backgroundColor = .red
        default:
            self.view.backgroundColor = .white
        }
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: Notification.Name("ScrollViewDidScroll"), object: scrollView.contentOffset.y)
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
