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
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as? homeViewController else{
        assertionFailure("123")
        return
                }
        guard let recordVC = storyboard?.instantiateViewController(withIdentifier: "recordViewController") as? recordViewController else{
            assertionFailure("123")
            return
        }
        guard let addNoteVC = storyboard?.instantiateViewController(withIdentifier: "addNoteViewController") as? addNoteViewController else{
            assertionFailure("123")
            return
        }
        guard let shopVC = storyboard?.instantiateViewController(withIdentifier: "shopViewController") as? shopViewController else{
            assertionFailure("123")
            return
        }
        guard let meVC = storyboard?.instantiateViewController(withIdentifier: "meViewController") as? meViewController else{
            assertionFailure("123")
            return
        }
        //        let item3 = UIViewController()
        //        let item4 = UIViewController()
        //        let item5 = UIViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(named: "icon_home"), selectedImage: UIImage(named: "icon_home_selected"))
        recordVC.tabBarItem = UITabBarItem(title: "紀錄", image: UIImage(named: "icon_record"), selectedImage: UIImage(named: "icon_record_selected"))
        addNoteVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon_record"), selectedImage: UIImage(named: "icon_record_selected"))
        shopVC.tabBarItem = UITabBarItem(title: "商城", image: UIImage(named: "icon_shop"), selectedImage: UIImage(named: "icon_shop_selected"))
        meVC.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "icon_me"), selectedImage: UIImage(named: "icon_me_selected"))
        
        
        // 將Tab Bar的項目添加到Tab Bar Controller中
        self.viewControllers = [homeVC,recordVC,addNoteVC,shopVC,meVC]
        self.tabBar.items?[2].isEnabled = false
        // 創建自定義按鈕
        let customButton = UIButton(type: .custom)
        customButton.setImage(UIImage(named: "add_btn"), for: .normal)
        customButton.frame.size = CGSize(width: 64, height: 64)
        customButton.center = CGPoint(x: tabBar.center.x, y: tabBar.center.y-32) // 調整y的位置
        
        
                // 添加按鈕點擊事件的處理程式
                customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        
                // 將自定義按鈕添加到Tab Bar Controller的view中
                self.view.addSubview(customButton)
                }
        
//         自定義按鈕點擊事件的處理程式
            @objc func customButtonTapped() {
            // 在這裡處理按鈕被點擊後的操作，例如切換到新的View Controller等
            // 這裡只是示範，你可以根據需求自行定義
            print("Custom Button Tapped!")
                print("\(self.tabBar.frame)")
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
