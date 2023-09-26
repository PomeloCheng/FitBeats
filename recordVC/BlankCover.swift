//
//  BlankCover.swift
//  HelloMySecurity
//
//  Created by YuCheng on 2023/9/6.
//

import UIKit

class BlankCover {
    static let shared = BlankCover()
    private init() {}
    
    //保存那個秀出來的VC
    private var coverVC: UIViewController?
    
    //把視窗擋住
    func showCover(window: UIWindow?) {
        
        //概念是：
        //當showCover出現時，就生出一個VC壓在最上面擋住
        //但真正難的是什麼時候出現，什麼時候消失
        
        //Dont show cover twice.
        guard coverVC == nil else { return }
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        coverVC = storyboard.instantiateViewController(withIdentifier: "CoverViewController")
        coverVC?.modalPresentationStyle = .fullScreen
        coverVC?.view.frame = UIScreen.main.bounds
        coverVC?.view.backgroundColor = .white
        if let vc = coverVC {
            window?.visibleViewController?.present(vc, animated: false) // no animation
        }
    }
    
    func dismissCover() {
        coverVC?.dismiss(animated: false)
        coverVC = nil
    }
}
