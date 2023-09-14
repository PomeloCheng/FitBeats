//
//  profileViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/13.
//

import UIKit

class profileViewController: UIViewController, UITextFieldDelegate {
    var maskView: UIView?
    var characterCountLabel : UILabel?
    var imagePicker: UIImagePickerController?
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        profileBG.layer.cornerRadius = 12
        profileBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        profileBG.layer.shadowColor = UIColor.lightGray.cgColor
        profileBG.layer.shadowOpacity = 0.2
        // Do any additional setup after loading the view.
        profileTable.dataSource = self
        profileTable.delegate = self
        
        // 添加点击手势识别器到 imageView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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

    @IBAction func cameraBtnPressed(_ sender: Any) {
        imageViewTapped()
    }
}


extension profileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
        
        switch indexPath.row {
        case 0:
            cell.profileLabel.text = "使用者名稱"
            cell.statusLabel.text = "未填寫"
        case 1:
            cell.profileLabel.text = "E-Mail"
            cell.statusLabel.text = "未填寫"
        case 2:
            cell.profileLabel.text = "手機號碼"
            cell.statusLabel.text = "未填寫"
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            setPopupText(messageTitle: "編輯使用者名稱")
        case 1:
            setPopupText(messageTitle: "編輯電子郵件")
        case 2:
            setPopupText(messageTitle: "手機號碼")
        default:
            break
        }
        
        }
        
}
