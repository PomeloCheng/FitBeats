//
//  setBigCalendar.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/9/1.
//

import Foundation
import FSCalendar
import MKRingProgressView



extension FSCViewController {
    
    
    func bigCalendarconfig() {
        bigCalendar.delegate = self
        bigCalendar.dataSource = self
        
        bigCalendar.scrollDirection = .vertical
        bigCalendar.firstWeekday = 2
        bigCalendar.appearance.headerDateFormat = "M月"
        bigCalendar.headerHeight = 80
        bigCalendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 24)
        bigCalendar.appearance.headerTitleColor = darkGreen
        bigCalendar.appearance.todayColor = redColor
        bigCalendar.appearance.headerSeparatorColor = .clear
        
        let headerX = self.view.bounds.width
        bigCalendar.appearance.headerTitleOffset = CGPoint(x: headerX / 3 + 28, y: 0)
        bigCalendar.pagingEnabled = false
        bigCalendar.placeholderType = .none
        
        // Do any additional setup after loading the view.
        bigCalendar.register(CustomCalendarCell.self, forCellReuseIdentifier: "CustomCalendarCell")
        
    }
    //設定CalendarCell
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        configindex = 1
        let cell = calendar.dequeueReusableCell(withIdentifier: "CustomCalendarCell", for: date, at: position) as! CustomCalendarCell
        
            //更新畫面的程式
            self.configureCustomView(cell.customView, for: date)
            cell.updateProgress(date: date)
        
        return cell
    }
    //設定ringProgress超過今天以後的日期都變透明
    func configureCustomView(_ customView: RingProgressView, for date: Date) {
        if date > Date() {
            customView.layer.opacity = 0.2
        } else {
            customView.layer.opacity = 1
        }
    }
    
    //滑動時更新上方title
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setHeaderTitle()
        }
    //設定title格式
    func calendar(_ calendar: FSCalendar, titleForHeaderFor date: Date) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M月"
            return dateFormatter.string(from: date)
        }
    //設定點擊之後傳回日期
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        bigCalendarVC!.updateDateTitle(date)
        calendarManager.shared.didSelectDate(date)
        self.dismiss(animated: true)
    }
    
    //設定日期的方法
    func setHeaderTitle() {
        var components = DateComponents()
        components.month = +1
        let currentPage = bigCalendar.currentPage
        guard let nextMonth = Calendar.current.date(byAdding: components, to: currentPage) else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月"
        let currentMonthString = dateFormatter.string(from: nextMonth)
        monthLabel.text = currentMonthString
    }
    
    func setPerviousMonth(){
        var components = DateComponents()
        components.month = -1
        let currentPage = bigCalendar.currentPage
        guard let previousMonth = Calendar.current.date(byAdding: components, to: currentPage) else {
        return
    }
        bigCalendar.setCurrentPage(previousMonth, animated: true)
        
    }
    
    
}
