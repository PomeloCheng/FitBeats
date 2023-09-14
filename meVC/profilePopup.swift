//
//  profilePopup.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/13.
//

import UIKit

extension profileViewController {
    @objc func okButtonTapped() {
        
        maskView?.removeFromSuperview()
        
    }
    
    
    
    @objc func cancelButtonTapped() {
        maskView?.removeFromSuperview()
        
    }
    
    func setPopupText(messageTitle: String){
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // 創建一個自定義的UIView，模擬警告框的效果
        let customAlertView = CustomAlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 162))
        customAlertView.backgroundColor = UIColor.white
        customAlertView.layer.cornerRadius = 15
        customAlertView.titleLabel.text = messageTitle
        // 設置自定義UIView在畫面中心
        customAlertView.center = view.center
        if messageTitle == "編輯使用者名稱" {
            customAlertView.textField.delegate = self
            customAlertView.textField.placeholder = "請輸入欲更改的暱稱"
            setChangeUserName()
            // 创建包含间距的容器视图
            let container = UIView(frame: CGRect(x: 0, y: 0, width: characterCountLabel!.frame.width + 12, height: 40))
            container.addSubview(characterCountLabel!)
            // 将字符计数标签设置为 UITextField 的 rightView
            customAlertView.textField.rightView = container
            customAlertView.textField.rightViewMode = .always // 始终显示 rightView
        }else{
            customAlertView.textField.placeholder = "請輸入E-Mail"
        }
        
        customAlertView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        customAlertView.cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
 
        // 將自定義的UIView添加到遮罩視圖上
        maskView.addSubview(customAlertView)
        self.view.addSubview(maskView)
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 获取当前文本框的文本
        
        
        let currentText = textField.text ?? ""
        
        // 计算新文本
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 检查新文本的长度是否超过了限制（这里假设限制为10个字符）
        let maxLength = 10
        if newText.count > maxLength {
            characterCountLabel?.textColor = UIColor.red
            return false // 不允许继续输入
        } else {
            // 更新字符计数标签
            characterCountLabel?.textColor = UIColor.lightGray
            characterCountLabel?.text = "\(newText.count) / \(maxLength)"
            return true // 允许输入
        }
    }
    
    func setChangeUserName(){
        characterCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        if let characterCountLabel = characterCountLabel {
            characterCountLabel.textAlignment = .right // 让字符计数右对齐
            characterCountLabel.textColor = UIColor.lightGray // 可选：设置字符计数的颜色
            characterCountLabel.font = UIFont.systemFont(ofSize: 11)
            
            characterCountLabel.text = "0 / 10"
        }
    
    }
    
}
