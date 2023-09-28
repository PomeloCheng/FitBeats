//
//  SMSViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/20.
//

import UIKit
import FirebaseAuth

class SMSViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inputPhoneNumber: UILabel!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    
    let userData = UserDataManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        inputPhoneNumber.text = userData.currentUserPhoneNumber
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self

        textField1.keyboardType = .phonePad
        textField2.keyboardType = .phonePad
        textField3.keyboardType = .phonePad
        textField4.keyboardType = .phonePad
        textField5.keyboardType = .phonePad
        textField6.keyboardType = .phonePad
        // Do any additional setup after loading the view.
        textField1.becomeFirstResponder()
        
    }
    
    @IBAction func backToPhoneNumber(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)//這個不管三七二十一直接關掉比較簡單
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 获取当前文本字段的文本
        var currentText = textField.text ?? ""
        
        // 只允许输入单个数字
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let inputCharacterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacterSet.isSuperset(of: inputCharacterSet) {
            return false
        }
        
        // 将输入字符附加到当前文本
        currentText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 更新文本字段的文本
        textField.text = currentText
        
        // 检查输入是否为单个数字，如果是，跳到下一个文本框
        if string.count == 1 {
            if let nextTextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                // 最后一个文本框，自动触发提交
                textField.resignFirstResponder()
                // 在此处添加提交代码
                if textField.tag == 6 {
                    // 最后一个文本框，执行提交操作
                    submitAction()
                }
            }
        }
        
        return false // 返回false以避免系统自动处理文本更改
    }
    
    func submitAction() {
        var combinedText = ""
        
        // 遍历所有的文本框
        for tag in 1...6 { // 假设你有六个文本框
            if let textField = view.viewWithTag(tag) as? UITextField {
                // 将文本框的文本内容添加到组合字符串中
                combinedText += textField.text ?? ""
            }
        }
       
        // 在这里执行你的提交逻辑，使用 combinedText 变量
        AuthManager.shared.verifyCode(smsCode: combinedText) { [weak self] success in
            guard success else { return }
          
            self?.userData.checkUserExists { result in
                if result {
                    self?.userData.fetchUserData()
                } else {
                    if let phoneNumber = self?.userData.currentUserPhoneNumber {
                        
                        UserDataManager.shared.createUserInFirestore(phoneNumber: phoneNumber)
                        self?.userData.fetchUserData()
                    }
                }
            }
            
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "Main", bundle: .main)
                let vc = storyBoard.instantiateViewController(withIdentifier: "mainScreen")
                self?.navigationController?.pushViewController(vc, animated: true)
            
            }
            
        }
        
        
    }
}
