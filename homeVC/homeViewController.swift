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

    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var homeRingView: RingProgressView!
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var targetBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        targetBG.layer.cornerRadius = 20
        targetBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        targetBG.layer.shadowColor = UIColor.lightGray.cgColor
        targetBG.layer.shadowOpacity = 0.2
        
        targetBG.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
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
   
}

