//
//  calendarManager.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/25.
//

import Foundation
import FSCalendar
import MKRingProgressView

protocol CalendarManagerDelegate: AnyObject {
    func updateDateTitle(_ date: Date)
}

let todayDate = Date()

class calendarManager:NSObject {
    var FSCalendar : FSCalendar!
    var selectedWeekdayLabel: UILabel?
    var circleView: UIView?
    
    
    weak var delegateMainVC: CalendarManagerDelegate?
    weak var delegateTableVC: CalendarManagerDelegate?
    let healthManager = HealthManager.shared
    
    
    static let shared = calendarManager()
    private override init() {}
    
    
    
    func setConfig(){
        
        FSCalendar.locale = .init(identifier: "zh-tw")
        
        FSCalendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        FSCalendar.firstWeekday = 2
        FSCalendar.weekdayHeight = 40
        FSCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 0) // Hide the title
        FSCalendar.headerHeight = 0
        FSCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        FSCalendar.delegate = self
        FSCalendar.dataSource = self
        FSCalendar.appearance.todayColor = .clear
        FSCalendar.appearance.weekdayTextColor = .black
        FSCalendar.allowsSelection = false
        
    }
    
    
    func setSelection(labelFrame: CGRect,weekdayLabel: UILabel,color: UIColor) {
        // 添加紅色圓圈
        let circleRadius: CGFloat = 12.0
        let circleYOffset: CGFloat = 0 // 調整Y的偏移量，根據需要調整
        let circleFrame = CGRect(x: labelFrame.midX - circleRadius, y: labelFrame.midY - circleYOffset - circleRadius, width: circleRadius * 2, height: circleRadius * 2)
        circleView = UIView(frame: circleFrame)
        circleView?.backgroundColor = color // 填滿紅色
        
        
        // 設定圓角半徑以達到圓形效果
        circleView?.layer.cornerRadius = circleRadius
        circleView?.clipsToBounds = true
        
        if let superView = weekdayLabel.superview, let circleView = circleView {
                        superView.insertSubview(circleView, belowSubview: weekdayLabel)
                    }
        
        // 添加動畫效果
        circleView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
                self.circleView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
                    self.circleView?.transform = CGAffineTransform.identity
                }
            }
    }
    
    func selectTodayWeekdayLabel() {
        resetSelectedState()

        var weekdayIndex = Calendar.current.component(.weekday, from: todayDate) - 2// 轉換成 0-6 的索引
        if weekdayIndex < 0 {
            weekdayIndex = 6
        }
        let todayWeekdayLabel = FSCalendar.calendarWeekdayView.weekdayLabels[weekdayIndex]
        let labelFrame = todayWeekdayLabel.frame
        selectedWeekdayLabel = todayWeekdayLabel
        todayWeekdayLabel.textColor = .white
        setSelection(labelFrame: labelFrame, weekdayLabel: todayWeekdayLabel, color: redColor)
    }
    
    func resetSelectedState() {
        selectedWeekdayLabel?.textColor = .black // 還原為初始顏色
        

            // 移除圓圈的 UIView
            circleView?.removeFromSuperview()
            circleView = nil
        
        }
    
    func calculateSelectedDate(weekdayIndex: Int) -> Date {
        let calendar = Calendar.current
        //calendar.timeZone = TimeZone.init(identifier: "Asia/Taipei")!
        let currentDate = FSCalendar.currentPage
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        let daysToAdd = weekdayIndex - currentWeekday + 2
        
        let selectedDate = calendar.date(byAdding: .day, value: daysToAdd, to: currentDate) ?? currentDate
        return calendar.startOfDay(for: selectedDate) // 只取日期部分，不包含時間
        
    }
    
    @objc func weekdayLabelTapped(_ sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: FSCalendar)
        
        for (index, weekdayLabel) in FSCalendar.calendarWeekdayView.weekdayLabels.enumerated() {
            
            let labelFrame = weekdayLabel.frame
            let customViewFrame = CGRect(x: labelFrame.origin.x, y: labelFrame.maxY, width: 40, height: 40)
            if customViewFrame.contains(tapLocation) || labelFrame.contains(tapLocation) {
                // 在這裡處理點擊星期標籤的邏輯，切換到對應日期
                // 例如，根據點擊的星期標籤，計算並設置日曆顯示的日期範圍
                
                // 取消上一次選取的效果（如果有）
                resetSelectedState()
                
                // 更新選取的標籤外觀
                selectedWeekdayLabel = weekdayLabel
                
                selectedWeekdayLabel?.textColor = .white // 選取的顏色
                
                // 更新日期標籤
                let selectedDate = calculateSelectedDate(weekdayIndex: index)
                delegateMainVC?.updateDateTitle(selectedDate) // 通知代理
                delegateTableVC?.updateDateTitle(selectedDate)
                
                if Calendar.current.isDateInToday(selectedDate) {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: redColor)
                } else {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: .gray)
                }
                
                
                break
            }
        }
    }
    
    func dateToWeekday(_ date: Date) {
        var calendar = Calendar.current
        //calendar.timeZone = TimeZone.init(identifier: "Asia/Taipei")!
        calendar.firstWeekday = 2
        let weekdayComponents = calendar.component(.weekday, from: date) - 2
        let weekdayLabels = FSCalendar.calendarWeekdayView.weekdayLabels
        
        for (index, weekdayLabel) in weekdayLabels.enumerated() {
            
            let labelFrame = weekdayLabel.frame
            if index == weekdayComponents {
                
                resetSelectedState()
                // 更新選取的標籤外觀
                selectedWeekdayLabel = weekdayLabels[index]
                
                selectedWeekdayLabel?.textColor = .white // 選取的顏色

                if Calendar.current.isDateInToday(date) {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: redColor)
                } else {
                    setSelection(labelFrame: labelFrame, weekdayLabel: weekdayLabel, color: .gray)
                }
            }
            
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        if let selectedWeekdayLabel = selectedWeekdayLabel {
            // 使用選取的星期標籤索引計算日期
            if let weekdayIndex = FSCalendar.calendarWeekdayView.weekdayLabels.firstIndex(of: selectedWeekdayLabel) {
                let selectedDate = calculateSelectedDate(weekdayIndex: weekdayIndex)
                
                dateToWeekday(selectedDate)
                
                delegateMainVC?.updateDateTitle(selectedDate) // 通知代理
                delegateTableVC?.updateDateTitle(selectedDate)
            }
        }
    }
    
    func didSelectDate(_ date: Date) {
        // 在這裡處理所選日期的邏輯，例如更新星期標籤和標題
        // 您可以直接使用傳遞的日期而無需重新計算
        // 例如：dateToWeekday(date)
        // 更新日期標籤和標題
        FSCalendar.currentPage = date
        delegateMainVC?.updateDateTitle(date)
        delegateTableVC?.updateDateTitle(date)
        dateToWeekday(date)
    }
    
    
   

}

extension Date {
    func addDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        //calendar.timeZone = TimeZone.init(identifier: "Asia/Taipei")!
        return calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    
    
}

extension calendarManager: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        configindex = 0
        let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
        cell.updateProgress(date: date)
        
        return cell
    }
    
   

}
