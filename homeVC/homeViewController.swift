//
//  ViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import MKRingProgressView
import Lottie
import FSCalendar

class homeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var changePetBtn: UIImageView!
    @IBOutlet weak var petCategoryBtn: UIImageView!
    @IBOutlet weak var introBtn: UIImageView!
    @IBOutlet weak var homeCheckLabel: UILabel!
    @IBOutlet weak var homeCaroLabel: UILabel!
    @IBOutlet weak var currentPetName: UILabel!
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var homeRingView: RingProgressView!
    
    @IBOutlet weak var petImagView: UIImageView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var targetBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        targetBG.layer.cornerRadius = 20
        targetBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        targetBG.layer.shadowColor = UIColor.lightGray.cgColor
        targetBG.layer.shadowOpacity = 0.2
        
        targetBG.isUserInteractionEnabled = true
        let targetBGtapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetViewTapped))
        targetBG.addGestureRecognizer(targetBGtapGestureRecognizer)
        
        introBtn.isUserInteractionEnabled = true
        let introBtntapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(introBtnTapped))
        introBtn.addGestureRecognizer(introBtntapGestureRecognizer)
        
        changePetBtn.isUserInteractionEnabled = true
        let changePetBtntapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePetBtnTapped))
        changePetBtn.addGestureRecognizer(changePetBtntapGestureRecognizer)
        
        petCategoryBtn.isUserInteractionEnabled = true
        let petCategoryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(petCategoryBtnTapped))
        petCategoryBtn.addGestureRecognizer(petCategoryGestureRecognizer)
        
        homeRingView.startColor = UIColor.tintColor
        homeRingView.endColor = UIColor.tintColor
        homeRingView.gradientImageScale = 0.3
        homeRingView.ringWidth = 25
        homeRingView.progress = 0.0
        homeRingView.shadowOpacity = 0.0
//        checkAnimation.isHidden = true
//        cancelAnimation.isHidden = true
//        isGoalLabel.isHidden = true
//        healthTitleLabel.isHidden = true

        
        
        calendarView.locale = .init(identifier: "zh-tw")
        
        calendarView.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendarView.scope = .week
        calendarView.firstWeekday = 2
        calendarView.weekdayHeight = 40
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 0) // Hide the title
        calendarView.headerHeight = 0
        calendarViewHeight.constant = 200
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.appearance.weekdayTextColor = .black
        calendarView.allowsSelection = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let petName = UserDataManager.shared.currentUserData?["homePet"] as? String,
          let homeCheck = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int,
          let homeCaro = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
           
            DispatchQueue.main.async {
                
                self.currentPetName.text = petName
                self.homeCaroLabel.text = String(format: "%d", homeCaro)
                self.homeCheckLabel.text = String(format: "%d", homeCheck)
                
                if petName == "預設怪獸" {
                    self.petImagView.image = UIImage(named: "default_home.png")
                } else {
                    self.petImagView.image = logImage.shared.load(filename: petName)
                }
            }
            }
        
        //fetch會呼叫
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserData), name: .userProfileFetched, object: nil)
        
    }
    
    @objc func fetchUserData() {
        if let petName = UserDataManager.shared.currentUserData?["homePet"] as? String,
          let homeCheck = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int,
          let homeCaro = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
           
            DispatchQueue.main.async {
                
                UIView.animate(withDuration: 0.3) {
                    self.homeCheckLabel.layer.opacity = 0.0
                    self.homeCaroLabel.layer.opacity = 0.0
                    self.petImagView.layer.opacity = 0.0
                            }
                self.currentPetName.text = petName
                self.homeCaroLabel.text = String(format: "%d", homeCaro)
                self.homeCheckLabel.text = String(format: "%d", homeCheck)
                
                if petName == "預設怪獸" {
                    self.petImagView.image = UIImage(named: "default_home.png")
                } else {
                    self.petImagView.image = logImage.shared.load(filename: petName)
                }
                UIView.animate(withDuration: 0.1) {
                    self.homeCheckLabel.layer.opacity = 1.0
                    self.homeCaroLabel.layer.opacity = 1.0
                    self.petImagView.layer.opacity = 1.0
                            }
            }
            }
            
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendarViewHeight.constant = bounds.height
    self.view.layoutIfNeeded()
    }
    
    @objc func targetViewTapped() {
        // 获取对应的UITabBarController
            if let tabBarController = self.tabBarController {
                // 设置要切换到的选项卡的索引（假设索引0代表第一个选项卡，1代表第二个选项卡，以此类推）
                let tabIndexToSwitch = 1 // 例如，切换到第二个选项卡
                tabBarController.selectedIndex = tabIndexToSwitch
            }
    }
    
    @objc func changePetBtnTapped() {
        let storyBoard = UIStoryboard(name: "home", bundle: .main)
        if let userPcoketVC = storyBoard.instantiateViewController(withIdentifier: "userPocketViewController") as? userPocketViewController {
            
            present(userPcoketVC, animated: true)
        }
    }
    
    
    @objc func introBtnTapped() {
        let storyBoard = UIStoryboard(name: "me", bundle: .main)
        if let introVC = storyBoard.instantiateViewController(withIdentifier: "infoViewController") as? infoViewController {
            introVC.isHomePresent = true
            
            present(introVC, animated: true)
        }
    }
    
    @objc func petCategoryBtnTapped() {
        
        let storyBoard = UIStoryboard(name: "me", bundle: .main)
        if let handbookVC = storyBoard.instantiateViewController(withIdentifier: "handbookViewController") as? handbookViewController {
            handbookVC.isHomePresent = true
            present(handbookVC, animated: true)
        }
    }
   
}

