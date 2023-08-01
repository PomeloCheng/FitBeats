//
//  CustomTabBarController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/1.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 設置Tab Bar的項目
        // 實例化homeViewController
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as? homeViewController {
        homeVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(named: "icon_home"), selectedImage: UIImage(named: "icon_home_selected"))
        // 將homeVC添加到Tab Bar Controller的viewControllers中
        viewControllers?.append(homeVC)
                }
                
        // 實例化recordViewController
        if let recordVC = storyboard?.instantiateViewController(withIdentifier: "recordViewController") as? recordViewController {
        recordVC.tabBarItem = UITabBarItem(title: "紀錄", image: UIImage(named: "icon_record"), selectedImage: UIImage(named: "icon_record_selected"))
        // 將recordVC添加到Tab Bar Controller的viewControllers中
        viewControllers?.append(recordVC)
                }
        //        let item3 = UIViewController()
        //        let item4 = UIViewController()
        //        let item5 = UIViewController()
        
//        home.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(named: "icon_home"), selectedImage: UIImage(named: "icon_home_selected"))
//        record.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(named: "icon_record"), selectedImage: UIImage(named: "icon_record_selected"))
        //        item3.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        //        item4.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
        //        item5.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 4)
        
        // 將Tab Bar的項目添加到Tab Bar Controller中
//        self.viewControllers = [home,record]
        
        //        // 創建自定義按鈕
        //        let customButton = UIButton(type: .custom)
        //        customButton.setImage(UIImage(named: "custom_icon"), for: .normal)
        //        customButton.frame.size = CGSize(width: 64, height: 64)
        //        customButton.center = CGPoint(x: self.tabBar.center.x, y: self.tabBar.center.y - 16)
        //
        //        // 添加按鈕點擊事件的處理程式
        //        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        //
        //        // 將自定義按鈕添加到Tab Bar Controller的view中
        //        self.view.addSubview(customButton)
        //        }
        
        // 自定義按鈕點擊事件的處理程式
        //    @objc func customButtonTapped() {
        //    // 在這裡處理按鈕被點擊後的操作，例如切換到新的View Controller等
        //    // 這裡只是示範，你可以根據需求自行定義
        //    print("Custom Button Tapped!")
        //    }
        
        
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
