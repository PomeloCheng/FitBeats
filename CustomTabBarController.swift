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
        
        // 創建自定義按鈕
        if let image = UIImage(named: "add_btn") {
            let customButton = UIButton(type: .custom)
            customButton.setImage(image, for: .normal)
            
            customButton.frame = CGRect(x: tabBar.center.x - image.size.width/2, y: tabBar.frame.origin.y - image.size.width/2, width: image.size.width, height: image.size.height)
            print("\(tabBar.frame.origin.y)")
            print("\(tabBar.center.y)")
            //customButton.center = CGPoint(x: tabBar.center.x, y: tabBar.frame.origin.y ) // 調整y的位置
            
            
            // 添加按鈕點擊事件的處理程式
            customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
            
            // 將自定義按鈕添加到Tab Bar Controller的view中
            self.view.addSubview(customButton)
        }
        
        
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
