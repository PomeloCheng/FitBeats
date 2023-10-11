//
//  smallRecordContentVC.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/31.
//

import UIKit
import HealthKit


class smallRecordContentVC: UIViewController, UITableViewDataSource, UITableViewDelegate,CalendarManagerDelegate {
    func updateDateTitle(_ date: Date) {
        
        healthManager.readWorkData(for: date) { exerciseDatas in
            if let exerciseDatas = exerciseDatas {
                self.exerciseData = exerciseDatas
                self.selectDate = date
                    DispatchQueue.main.async {
                        self.recordTable.reloadData()
                    }
            } 
        }
        
    }
    

    @IBOutlet weak var recordTable: UITableView!
    
    var exerciseData: [HKWorkout] = []
    let healthManager = HealthManager.shared
    let setWorkHelper = setWorkCellData.shared
    var selectDate: Date?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarManager.shared.delegateTableVC = self
        
        if let selectDate = selectDate {
            if selectDate == todayDate{
                updateDateTitle(todayDate)
            } else {
                updateDateTitle(selectDate)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTodayTableView), name: Notification.Name("reloadTableView"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.dataSource = self
        recordTable.delegate = self
        view.backgroundColor = .white
        recordTable.separatorStyle = .none
        recordTable.backgroundColor = .white
       
        
    }
    //MARK: reloadTable
    @objc func reloadTodayTableView() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadTableView"), object: nil)

        DispatchQueue.main.async {
            self.updateDateTitle(todayDate)
        }
        
    }
    
//MARK: tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !exerciseData.isEmpty {
            return exerciseData.count
        } else {
            return 0
        }
    }
    
    // 定義一個 OperationQueue，用於執行操作
    let operationQueue = OperationQueue()

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordItemCell") as! recordTableCell
        let workout = exerciseData[indexPath.row]
        let (image, title, caloriesBurnedString) = setWorkHelper.setCellIconandTitle(for: workout)
    
        cell.recordIcon.image = image
        cell.recordIcon.contentMode = .scaleAspectFit
        cell.sportNameLabel.text = title
        
        let totaldistance = workout.totalDistance
        
        
        healthManager.searchWorkOutData(workout) { locationinfo,error  in
                
                if let error = error {
                    print("location fail: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    if let locationinfo = locationinfo,
                       let totaldistance = totaldistance {
                        cell.nameHight.constant = 28
                        cell.location.text = locationinfo
                        cell.location.isHidden = false
                        cell.locationIcon.isHidden = false
                        
                        let distance = totaldistance.doubleValue(for: HKUnit.meter()) / 1000.0
                        cell.calorieLabel.text = String(format: "%.2f 公里",distance)
                    }
                    else {
                        cell.nameHight.constant = 40
                        cell.location.isHidden = true
                        cell.locationIcon.isHidden = true
                        cell.calorieLabel.text = "消耗 " + (caloriesBurnedString ?? "0 大卡")
                    }
                    
                }
                
            }
        
        
        
        
        let duringtime = setWorkHelper.formatTimeInterval(workout.duration)
        cell.during.text = "總計" + duringtime
        
        cell.recordItemView.layer.cornerRadius = 18
        
        cell.recordItemView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.recordItemView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.recordItemView.layer.shadowOpacity = 0.2
        
        
        //
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "record", bundle: nil) // 替換 "Main" 為你的故事板名稱
        guard let targetVC = storyboard.instantiateViewController(withIdentifier: "TargetViewController") as? TargetViewController else {
            assertionFailure("instantiateViewController fail")
            return
        }

        targetVC.workout = exerciseData[indexPath.row]
        targetVC.selectDate = selectDate
        
            // 使用導航控制器將目標視圖控制器推送到堆疊中
            navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
}
