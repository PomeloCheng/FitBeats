//
//  AccountViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/20.
//

import UIKit
import iOSDropDown

class AccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var conturyCode: DropDown!
    var maskView: UIView?
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var wrongType: UILabel!
    @IBOutlet weak var phoneNumberField: UITextField!
    var countdownTimer: Timer?
    var countdownSeconds = 60 // 设置倒计时秒数
    
    let userData = UserDataManager.shared
    var selectContryCode = "+886"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberField.delegate = self
        phoneNumberField.keyboardType = .phonePad
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        let countryCodes = [
            
            "+1",
            "+44",
            "+93",
            "+54",
            "+43",
            "+61",
            "+973",
            "+880",
            "+32",
            "+975",
            "+591",
            "+55",
            "+855",
            "+237",
            "+86",
            "+1264",
            "+1268",
            "+297",
            "+1441",
            "+1767",
            "+1473",
            "+1758",
            "+57",
            "+243",
            "+41",
            "+49",
            "+45",
            "+20",
            "+34",
            "+503",
            "+358",
            "+679",
            "+33",
            "+995",
            "+233",
            "+30",
            "+502",
            "+967",
            "+509",
            "+504",
            "+852",
            "+91",
            "+354",
            "+62",
            "+964",
            "+353",
            "+39",
            "+1876",
            "+962",
            "+7",
            "+254",
            "+81",
            "+82",
            "+965",
            "+352",
            "+853",
            "+389",
            "+261",
            "+60",
            "+960",
            "+52",
            "+212",
            "+47",
            "+674",
            "+64",
            "+505",
            "+234",
            "+92",
            "+507",
            "+675",
            "+351",
            "+595",
            "+40",
            "+7",
            "+250",
            "+966",
            "+381",
            "+248",
            "+94",
            "+65",
            "+249",
            "+46",
            "+66",
            "+886",
            "+676",
            "+90",
            "+256",
            "+380",
            "+971",
            "+598",
            "+998",
            "+58",
            "+967"
        ]
        // 设置下拉列表的数据源
        conturyCode.optionArray = countryCodes
        
        // 设置选择回调
        conturyCode.didSelect { (selectedText, index, id) in
                // 在这里处理用户选择的国家/地区代码
                print("Selected Country: \(selectedText)")
                // 如果需要获取所选的国家/地区代码，可以使用 index 作为键
            self.selectContryCode = selectedText
                
            }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)//這個不管三七二十一直接關掉比較簡單
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 在视图即将消失时停止计时器
        countdownTimer?.invalidate()
        countdownTimer = nil
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
        submitBtn.isEnabled = false
        submitBtn.setTitleColor(UIColor.gray, for: .disabled)
        submitBtn.backgroundColor = UIColor(red: 225/255, green: 227/255, blue: 234/255, alpha: 1)
        startCountdown()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        
        if let text = phoneNumberField.text, !text.isEmpty{
            let number = selectContryCode + text
            userData.currentUserPhoneNumber = text
            print(number)
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                guard success else {
                    
                    DispatchQueue.main.async {
                        self?.alert()
                    }
                    return }
                
                DispatchQueue.main.async {
                    let vc = storyBoard.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func startCountdown() {
        countdownSeconds = 60 // 重置倒计时秒数
        countdownTimer?.invalidate() // 先停止之前的计时器
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            // 更新按钮标题为剩余秒数
            self.submitBtn.setTitle("等待跳轉 \(self.countdownSeconds)s 後可再次發送", for: .disabled)
            
            if self.countdownSeconds == 0 {
                // 倒计时结束，恢复按钮状态
                self.countdownTimer?.invalidate()
                self.submitBtn.isEnabled = true
                self.submitBtn.setTitle("獲取驗證碼", for: .normal)
                self.submitBtn.backgroundColor = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
                self.submitBtn.setTitleColor(UIColor.white, for: .normal)
            }
            
            self.countdownSeconds -= 1
        }
    }
    
    func alert() {
        
        maskView = UIView(frame: view.bounds)
        guard let maskView = maskView else {
            assertionFailure("create maskView fail")
            return
        }
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let alert = popAlertView()
        alert.frame = CGRect(x: 0, y: 0, width: 300, height: 192)
        alert.cancleButton.isHidden = true
        alert.setOKBtn(isShow: true)
        alert.okButton.addTarget(self, action: #selector(okBuyButtonTapped), for: .touchUpInside)
        alert.cancleButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 15
        alert.messageLabel.text = "授權失敗請稍後再試"
        
        alert.center = view.center
        maskView.addSubview(alert)
        self.view.addSubview(maskView)
    }
    
    @objc func cancelButtonTapped() {
        maskView?.removeFromSuperview()
        
    }
    
    @objc func okBuyButtonTapped() {
        maskView?.removeFromSuperview()
        
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
