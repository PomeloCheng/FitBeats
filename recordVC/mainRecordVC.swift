//
//  ViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/24.
//

import UIKit
import FSCalendar
import MKRingProgressView
import HealthKit
import Lottie

var tapRecord = false
var configindex: Int?
var appStart = false //判斷啟動App 回來時reloadData
//var darkGreen = UIColor(red: 0, green: 138/255, blue: 163/255, alpha: 1)
var darkGreen = UIColor(red: 0, green: 190/255, blue: 164/255, alpha: 1)
var lightGreen = UIColor(red: 232/255, green: 246/255, blue: 245/255, alpha: 1)
var redColor = UIColor(red: 239/255, green: 115/255, blue: 110/255, alpha: 1)



class mainRecordVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, CalendarManagerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var isGoalLabel: UILabel!
    @IBOutlet weak var cancelAnimation: LottieAnimationView!
    @IBOutlet weak var checkAnimation: LottieAnimationView!
    @IBOutlet weak var caroGoalLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var caroLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var recordView: UIView!
    //var isFirstTime = true //第一次的顯示todayLabel
    //var isFirstRead = true //第一次進來設定月曆
    
    var isNil = false //判斷資料是否為nil彈出警告 從授權那邊更改成true之後都判斷
    @IBOutlet weak var calendarView: FSCalendar!
    
    var selectData: Date?
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    var tapGesture: UITapGestureRecognizer?
    let healthManager = HealthManager.shared
    
    
    
    @IBOutlet weak var healthTitleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !tapRecord {
            calendarManager.shared.FSCalendar = calendarView
            calendarViewHeight.constant = 200
            calendarManager.shared.setConfig()
            calendarManager.shared.delegateMainVC = self
            calendarManager.shared.FSCalendar.currentPage = todayDate
            updateDateTitle(todayDate)
            
            NotificationCenter.default.post(name: Notification.Name("reloadTableView"), object: nil)
           // isFirstRead = false // 设置为 false，以确保不再执行此部分代码
        } else {
            if let selectData = selectData {
                calendarManager.shared.dateToWeekday(selectData)
            }

        }
        
        healthManager.checkHealthDataAuthorizationStatus { result, error in
            if let error = error {
                print("checkHealthDataAuthorizationStatus fail:\(error)")
                return
            }
            if result { self.isNil = true }
        }
        
        refreshCalendar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !tapRecord {
            calendarManager.shared.selectTodayWeekdayLabel()
            
            
        }else{
            tapRecord = false
        }
        
        
      
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        calendarManager.shared.resetSelectedState()
        //leaveVC = true
    }
    
    @IBOutlet weak var ringView: RingProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // Do any additional setup after loading the view
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture?.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture!)
        
        calendarView.scope = .week
        ringView.startColor = darkGreen
        ringView.endColor = darkGreen
        ringView.gradientImageScale = 0.3
        ringView.ringWidth = 25
        ringView.progress = 0.0
        ringView.shadowOpacity = 0.0
        checkAnimation.isHidden = true
        cancelAnimation.isHidden = true
        isGoalLabel.isHidden = true
        healthTitleLabel.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuthorizationSuccess), name: Notification.Name("HealthKitAuthorizationSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCalendar), name: .refreshRecordCalendar, object: nil)


//        if leaveVC {
//            calendarView.reloadData()
//            leaveVC = false
//        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        calendarManager.shared.weekdayLabelTapped(sender)
    }
    
    @objc func refreshCalendar() {
        
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            // 在這裡重新載入數據
            self.calendarView.reloadData()
        }, completion: nil)
        NotificationCenter.default.removeObserver(self, name: .refreshRecordCalendar, object: nil)
        
    }
    
    func updateDateTitle(_ date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy 年 MM 月 dd 日"
        //dateFormatter.timeZone = TimeZone.current // 使用本地时区
            let dateString = dateFormatter.string(from: date)
        
        navigationItem.title = dateString
        updateProgress(date: date)
        selectData = date
        healthManager.readWorkData(for: date) { exerciseDatas in
            if let exerciseDatas = exerciseDatas {
                
                if !exerciseDatas.isEmpty {
                    DispatchQueue.main.async {
                        self.healthTitleLabel.isHidden = true
                    }
                }else{
                    DispatchQueue.main.async {
                        self.healthTitleLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    
    func updateProgress(date:Date) {
        
        if date > todayDate {
           
            setDefaultData()
            
        } else {
            
            self.ringView.layer.opacity = 1.0
            setHealthData(date)
        }
        
        
    }
    
    func setDefaultData(){
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.ringView.progress = 0
            })
            self.checkAnimation.isHidden = true
            self.cancelAnimation.isHidden = true
            self.isGoalLabel.isHidden = true
            self.ringView.layer.opacity = 0.2
            self.caroGoalLabel.text = " -- 大卡"
            self.distanceLabel.text = " -- 公里"
            self.stepLabel.text = " -- 步"
            self.caroLabel.text = " -- 大卡"
    }
    
    func setHealthData(_ date: Date){
//        healthManager.readStepDistance(for: date) { activeTime in
//            guard let activeTime = activeTime else {
//                DispatchQueue.main.async {
//                    self.activeTimeLabel.text = " -- 分鐘"
//                }
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.activeTimeLabel.text = String(format: "%.0f 分鐘",activeTime)
//            }
//
//        }
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
            guard let progress = progress,let calories = calories,let goal = goal else {
                
                DispatchQueue.main.async {
                //更新畫面的程式
                    
                    self.ringView.progress = 0
                    self.ringView.layer.opacity = 0.2
                    self.caroLabel.text = " -- 大卡"
                    self.caroGoalLabel.text = " -- 大卡"
                    
                }
                

                return
            }
           
            DispatchQueue.main.async {
                //更新畫面的程式
                self.caroLabel.text = String(format: "%.0f 大卡",calories)
                self.caroGoalLabel.text = String(format: "%.0f 大卡",goal)
                
                if progress >= 1.0 {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self.ringView.progress = 1.0
                    })
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
                        self.ringView.progress = progress
                    })
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
        
        healthManager.readCalories(for: date) { calories, progress, selectGoal in
            self.healthManager.readStepCount(for: date) { selectStep in
                
                if calories == nil && selectGoal == nil && selectStep == 0 {
                    if self.isNil {
                        DispatchQueue.main.async {
                            self.checkAnimation.isHidden = true
                            self.cancelAnimation.isHidden = true
                            self.caroLabel.text = " -- 大卡"
                            self.caroGoalLabel.text = " -- 大卡"
                            self.stepLabel.text = " -- 步"
                            self.distanceLabel.text = "  -- 公里"
                            self.showHealthKitAuthorizationAlert()
                        }
                        
                    }
                    return
                }
            }
        }
        
        
        
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     self.calendarViewHeight.constant = bounds.height
    self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     

        
        if segue.identifier == "fullCalendar",
           let nextVC = segue.destination as? FSCViewController {
            nextVC.bigCalendarVC = self
        }
        
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleAuthorizationSuccess() {
       
        DispatchQueue.main.async {
            //更新畫面的程式
            self.updateDateTitle(todayDate)
            self.calendarView.reloadData()
            self.isNil = true
            
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("HealthKitAuthorizationSuccess"), object: nil)
        
        
        
    }
    
    func reloadCalendar() {
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.calendarView.reloadData()
        }, completion: nil)
    }

    
}
    
