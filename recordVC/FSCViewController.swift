//
//  FSCViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/8/26.
//

import UIKit
import FSCalendar
import MKRingProgressView
class FSCViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet weak var bigCalendar: FSCalendar!
    
    var bigCalendarVC : mainRecordVC?
    let healthManager = HealthManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setPerviousMonth()
        setHeaderTitle()
        bigCalendarconfig()
        }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
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



