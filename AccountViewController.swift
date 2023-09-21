//
//  AccountViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/20.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var wrongType: UILabel!
    @IBOutlet weak var phoneNumberField: UITextField!
    var userNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberField.delegate = self
        phoneNumberField.keyboardType = .phonePad
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 检查当前文本框的文本
        if let text = textField.text {
                // 计算将要输入的文本
                let newText = (text as NSString).replacingCharacters(in: range, with: string)
                
                // 检查字符数是否超过限制
                if newText.count > 10 {
                    // 超过字符限制，显示错误消息和禁用按钮
                    wrongType.isHidden = false
                    submitBtn.isEnabled = false
                    submitBtn.backgroundColor = UIColor.systemGray6
                    
                } else {
                    // 字符数未超过限制，隐藏错误消息和启用按钮
                    wrongType.isHidden = true
                    submitBtn.isEnabled = true
                    submitBtn.backgroundColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
                    
                }
            }
            
            // 允许用户输入文本
            return true
        }
    
    
    @IBAction func submitPhoneNumber(_ sender: Any) {
        phoneNumberField.resignFirstResponder()
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        
        if let text = phoneNumberField.text, !text.isEmpty {
            let number = "+886\(text)"
            self.userNumber = number
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                guard success else { return }
                
                DispatchQueue.main.async {
                    let vc = storyBoard.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
                    vc.phoneNumber = self?.userNumber ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
