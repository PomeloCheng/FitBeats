//
//  meViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/1.
//

import UIKit
import SafariServices

class meViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var tableViewBG: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var currencyBG: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currencyBG.layer.cornerRadius = 12
        currencyBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        currencyBG.layer.shadowColor = UIColor.lightGray.cgColor
        currencyBG.layer.shadowOpacity = 0.2
        
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        logoutBtn.layer.shadowColor = UIColor.lightGray.cgColor
        logoutBtn.layer.shadowOpacity = 0.2
        
        tableViewBG.layer.cornerRadius = 12
        tableViewBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        tableViewBG.layer.shadowColor = UIColor.lightGray.cgColor
        tableViewBG.layer.shadowOpacity = 0.2
        // Do any additional setup after loading the view.
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func imageViewTapped() {
        setVC(VCName: "profileViewController")
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

extension meViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! settingViewCell
        
        
        switch indexPath.row {
        case 0:
            cell.settingIcon.image = UIImage(systemName: "gearshape.fill")
            cell.settingLabel.text = "個人檔案"
        case 1:
            cell.settingIcon.image = UIImage(systemName: "info.circle.fill")
            cell.settingLabel.text = "使用說明"
        case 2:
            cell.settingIcon.image = UIImage(systemName: "books.vertical.fill")
            cell.settingLabel.text = "服務條款與隱私政策"
        case 3:
            cell.settingIcon.image = UIImage(systemName: "book.closed.fill")
            cell.settingLabel.text = "怪獸圖鑑"
        default:
            cell.settingIcon.image = UIImage(systemName: "ellipsis.circle.fill")
            cell.settingLabel.text = "預設"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
            setVC(VCName: "profileViewController")
            case 1:
            setVC(VCName: "infoViewController")
            case 2:
            setVC(VCName: "Privacy")
            case 3:
            setVC(VCName: "handbookViewController")
            default:
                break
            }
        
    }
    
    func setVC(VCName: String){
        let storyboard = UIStoryboard(name: "me", bundle: .main)
        var nextVC: UIViewController
        switch VCName {
            
        case "profileViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! profileViewController
            navigationController?.pushViewController(nextVC, animated: true)
        case "infoViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! infoViewController
            navigationController?.pushViewController(nextVC, animated: true)
        case "Privacy":
            if let url = URL(string: "https://www.privacypolicies.com/live/0907b983-940a-47d5-adf2-7c06c6baf582") {
                    let safariViewController = SFSafariViewController(url: url)
                    present(safariViewController, animated: true, completion: nil)
                }
        case "handbookViewController":
            nextVC = storyboard.instantiateViewController(withIdentifier: VCName) as! handbookViewController
            navigationController?.pushViewController(nextVC, animated: true)
        default:
            break
        }
        
    }
    
}
