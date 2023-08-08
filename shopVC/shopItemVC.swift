//
//  shopItemVC.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/8.
//

import UIKit
import XLPagerTabStrip
let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
class shopItemVC: ButtonBarPagerTabStripViewController {
    
    

    override func viewDidLoad() {
        configure()
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    private func configure(){
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 20)
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarMinimumLineSpacing = 12
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 100
        settings.style.buttonBarRightContentInset = 100
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = .black
        newCell?.label.textColor = purpleInspireColor
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let childIdentifiers = ["Child1", "Child2"]
        var childViewControllers: [UIViewController] = []

        for identifier in childIdentifiers {
            let childVC = UIStoryboard(name: "shop", bundle: nil).instantiateViewController(withIdentifier: "VC1") as! ChildController1
        childVC.identifier = identifier
        childViewControllers.append(childVC)
    }

    return childViewControllers
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
