//
//  ViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import MKRingProgressView
import Lottie
import HealthKit
import FSCalendar
import Firebase
import AppTrackingTransparency

class homeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var updateFailData: UIButton!
    var isNil = false //判斷資料是否為nil彈出警告 從授權那邊更改成true之後都判斷
    @IBOutlet weak var evlotionAnimate: LottieAnimationView!
    @IBOutlet weak var homePetExperienceLabel: UILabel!
    
    @IBOutlet weak var experienceView: UIProgressView!
    @IBOutlet weak var lvLabel: UILabel!
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
    
    
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var cancelAnimation: LottieAnimationView!
    @IBOutlet weak var checkAnimation: LottieAnimationView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    
    @IBOutlet weak var isGoalLabel: UILabel!
    
    let healthManager = HealthManager.shared
   
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
        
        calendarView.scope = .week
        calendarView.delegate = self
        calendarView.dataSource = self
        
        
        updateDateTitle(todayDate)
        ShopItemManager.shared.fetchProductData(categoryID: 0) { products in
            if let products = products {
                self.downloadAllImage(allProducts: products)
            }
        }
        
        
        ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .notDetermined:
                        break
                    case .restricted:
                        break
                    case .denied:
                        break
                    case .authorized:
                        break
                    @unknown default:
                        break
                    }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarManager.shared.selectTodayWeekdayLabel()
        appStart = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarManager.shared.FSCalendar = calendarView
        calendarViewHeight.constant = 200
        calendarManager.shared.setConfig()
        self.view.sendSubviewToBack(calendarView)
        
        calendarView.isUserInteractionEnabled = false
        setHomeUserData()
        
        //fetch會呼叫
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserData), name: .userProfileFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMonsterEx), name: .updateMonster, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failGetData), name: .failGetData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHomeCurrency), name: .setHomeCurrency, object: nil)
        
        healthManager.checkHealthDataAuthorizationStatus { result, error in
            if let error = error {
                print("checkHealthDataAuthorizationStatus fail:\(error)")
                return
            }
            if result { self.isNil = true }
        }
        
    }
    
    @objc func updateHomeCurrency() {
        NotificationCenter.default.removeObserver(self, name: .setHomeCurrency, object: nil)
        setHomeCurrency()
        
        
    }
    
    @objc func fetchUserData() {
        NotificationCenter.default.removeObserver(self, name: .userProfileFetched, object: nil)
        setHomeUserData()
        
        
    }
    @objc func failGetData() {
        NotificationCenter.default.removeObserver(self, name: .failGetData, object: nil)
        updateFailData.isEnabled = true
        updateFailData.isHidden = false
        
    }
    
    @IBAction func testEvoBtnPressed(_ sender: Any) {
    increaseExperience(5)
    }
    @IBAction func updateFailBtnPressed(_ sender: Any) {
        
        let currentDate = Date()
        let calendar = Calendar.current
        // 检查当前时间是否在触发时间之后
        guard let earliestBeginDate = earliestBeginDate else { return }
        
        if currentDate > earliestBeginDate {
            var dateComponents = DateComponents()
            dateComponents.day = -1
            
            // 使用 Calendar 來計算前一天的日期
            if let previousDate = calendar.date(byAdding: dateComponents, to: currentDate) {
                increaseEnergy(date: previousDate)
            }
            
        }else {
            increaseEnergy(date: currentDate)
        }
        updateFailData.isEnabled = false
        updateFailData.isHidden = true
        
    }
    private func increaseEnergy(date: Date) {
        // 在这里将能量值 X 增加 1234
        
        
        HealthManager.shared.readStepCount(for: date)  { step in
            var increaseNumber = 0
            if step < 1000 {
                increaseNumber = 0
            } else if step < 2000 {
                increaseNumber = 1
            } else if step < 3000 {
                increaseNumber = 2
            } else {
                increaseNumber = 3
            }
            self.increaseExperience(increaseNumber)
        }
        
        
        HealthManager.shared.readCalories(for: date) { calories, progress, _ in
            guard let calories = calories , let progress = progress else{
                NotificationCenter.default.post(name: .failGetData, object: nil)
                return
            }
            if let userCaroPoint = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int {
                let currentEnergy = userCaroPoint
                let newCaroPoint = currentEnergy + Int(calories)
                
                
                UserDataManager.shared.currentUserData?["CaloriesPoints"] = newCaroPoint
                DispatchQueue.main.async {
                    self.homeCaroLabel.text = String(format: "%d", newCaroPoint)
                }
                UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CaloriesPoints", fieldValue: newCaroPoint)
                
            }
            
            if let userCheckPoint = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int {
                
                if progress >= 1 {
                    let currentCheckPoint = userCheckPoint
                    let newCheckPoint = currentCheckPoint + 1
                    
                    UserDataManager.shared.currentUserData?["CheckinPoints"] = newCheckPoint
                    DispatchQueue.main.async {
                        self.homeCheckLabel.text = String(format: "%d", newCheckPoint)
                    }
                    UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CheckinPoints", fieldValue: newCheckPoint)
                    
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
    
    func updateDateTitle(_ date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy 年 MM 月 dd 日"
        //dateFormatter.timeZone = TimeZone.current // 使用本地时区
        let dateString = dateFormatter.string(from: date)
        
        todayLabel.text = dateString
        setHealthData(date)
        
    }
    
    
    func setHealthData(_ date: Date, retryCount: Int = 3){
        
        healthManager.readStepDistance(for: date) { distance in
            
            DispatchQueue.main.async {
                self.distanceLabel.text = String(format: "%.2f 公里",distance)
            }
            
        }
        
        healthManager.readStepCount(for: date) { step in
            
            DispatchQueue.main.async {
                self.stepLabel.text = String(format: "%.0f 步",step)
            }
            
        }
        
        
        healthManager.readCalories(for: date) { calories,progress,goal in
            guard let progress = progress,let calories = calories else {
                
                DispatchQueue.main.async {
                    //更新畫面的程式
                    self.checkAnimation.isHidden = true
                    self.cancelAnimation.isHidden = true
                    self.isGoalLabel.isHidden = true
                    self.homeRingView.progress = 0
                    self.homeRingView.layer.opacity = 0.2
                    self.caroLabel.text = " -- 大卡"
                    
                    
                }
                
                
                return
            }
            
            DispatchQueue.main.async {
                //更新畫面的程式
                self.caroLabel.text = String(format: "%.0f 大卡",calories)
                
                
                if progress >= 1.0 {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.homeRingView.progress = 1.0
                    })
                    self.homeRingView.layer.opacity = 1.0
                    self.checkAnimation.isHidden = false
                    self.cancelAnimation.isHidden = true
                    self.isGoalLabel.isHidden = false
                    self.isGoalLabel.text = "已達成目標"
                    self.isGoalLabel.textColor = darkGreen
                    let anim = LottieAnimation.named("check.json")
                    self.checkAnimation.animation = anim
                    self.checkAnimation.contentMode = .scaleAspectFill
                    self.checkAnimation.play()
                    
                } else {
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.homeRingView.progress = progress
                    })
                    self.homeRingView.layer.opacity = 1.0
                    self.checkAnimation.isHidden = true
                    self.cancelAnimation.isHidden = false
                    self.isGoalLabel.isHidden = false
                    self.isGoalLabel.text = "尚未達成目標"
                    self.isGoalLabel.textColor = redColor
                    
                    let anim = LottieAnimation.named("undone.json")
                    self.cancelAnimation.animation = anim
                    self.cancelAnimation.contentMode = .scaleAspectFill
                    self.cancelAnimation.play()
                }
            }
        }
        
        //三個都沒資料時
        healthManager.readCalories(for: date) { calories, progress, selectGoal in
            self.healthManager.readStepCount(for: date) { selectStep in
                
                if calories == nil && selectGoal == nil && selectStep == 0 {
                    if self.isNil {
                        
                        if retryCount > 0 {
                            // 如果没有数据，且还有重试次数，延迟一段时间后重新尝试
                            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                self.setHealthData(date, retryCount: retryCount - 1)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.checkAnimation.isHidden = true
                                self.cancelAnimation.isHidden = true
                                self.isGoalLabel.isHidden = true
                                self.homeRingView.progress = 0
                                self.homeRingView.layer.opacity = 0.2
                                self.caroLabel.text = " -- 大卡"
                                self.stepLabel.text = " -- 步"
                                self.distanceLabel.text = "  -- 公里"
                                
                            }
                        }
                    }
                    return
                }
            }
        }
        
    }
   
    @IBAction func refreshBtnPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            //更新畫面的程式
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                // 在這裡重新載入數據
                self.updateDateTitle(todayDate)
                UserDataManager.shared.fetchUserData()
                
                self.calendarView.reloadData()
                calendarManager.shared.selectTodayWeekdayLabel()
            }, completion: nil)
            
        }
        NotificationCenter.default.post(name: .refreshRecordCalendar, object: nil)
       
        
    }
    
    func reloadCalendar() {
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.calendarView.reloadData()
        }, completion: nil)
    }
    
    func downloadAllImage(allProducts: [fireBaseProduct]) {
        for productIndex in 0 ... allProducts.count - 1{
            let productName = allProducts[productIndex].productName
            
            if logImage.shared.load(filename: productName) != nil {
                continue
            } else {
                
                ShopItemManager.shared.fetchProductURL(productName: productName) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    
                    do {
                        try logImage.shared.save(data: imageData, filename: productName)
                    } catch {
                        print("write File error : \(error) ")
                    }
                }
            }
        }
    }
    
}
