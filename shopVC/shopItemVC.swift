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
        settings.style.selectedBarBackgroundColor = UIColor.tintColor
        settings.style.buttonBarItemFont = .systemFont(ofSize: 18)
        settings.style.selectedBarHeight = 5.0
        settings.style.buttonBarHeight = 40
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 16
        settings.style.buttonBarLeftContentInset = 24
        settings.style.buttonBarRightContentInset = 24

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = .black
        oldCell?.label.font = UIFont.systemFont(ofSize: 18)
        newCell?.label.textColor = UIColor.tintColor
        newCell?.label.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let category = [1, 2, 3, 4]
        var shopContentVCs: [UIViewController] = []

        for categoryTag in category {
            let storyboard = UIStoryboard(name: "shop", bundle: nil)
                    if let shopContentVC = storyboard.instantiateViewController(withIdentifier: "shopContentVC") as? shopContentVC {
                        shopContentVC.categoryTag = categoryTag
                        shopContentVCs.append(shopContentVC)
                    }
            
        }

        return shopContentVCs
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
