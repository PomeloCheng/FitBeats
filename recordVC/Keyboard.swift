//
//  keyboard.swift
//  HelloMyChatRoom
//
//  Created by YuCheng on 2023/7/26.
//

import Foundation
import UIKit

extension TargetViewController {
    
    @objc func keyboardShown(notification: Notification) {
        
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
                //取得鍵盤尺寸
                let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                
                //鍵盤頂部 Y軸的位置
                let keyboardY = self.view.frame.height - keyboardSize.height
                //編輯框底部 Y軸的位置
                let editingTextFieldY = textField.convert(textField.bounds, to: self.view).maxY
                //相減得知, 編輯框有無被鍵盤擋住, > 0 有擋住, < 0 沒擋住, 即是擋住多少
                let targetY = editingTextFieldY - keyboardY
                
                //設置想要多移動的高度
                let offsetY: CGFloat = 10
                
        
                if self.view.frame.minY >= 0 {
                    
                    if targetY > 0 {
                        UIView.animate(withDuration: 0.20, animations: {
                            self.view.frame = CGRect(x: 0, y:  -targetY - offsetY, width: self.view.bounds.width, height: self.view.bounds.height)
                        })
                    }
                }
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @objc func keyboardHidden(notification: Notification) {
        
        UIView.animate(withDuration: 0.20, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
                    
                })
        self.navigationController?.navigationBar.isHidden = false
    }
}


