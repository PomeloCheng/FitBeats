//
//  TargetViewController.swift
//  testCVcalendar
//
//  Created by YuCheng on 2023/9/5.
//

import UIKit
import HealthKit

import CoreData
import GoogleMobileAds


class TargetViewController: UIViewController, UITextViewDelegate, GADBannerViewDelegate {

   
    
    var bannerView: GADBannerView?
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var distanceTitle: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var dataBackground: UIView!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var totalCaro: UILabel!
    @IBOutlet weak var averageRate: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var workoutLoaction: UILabel!
    @IBOutlet weak var workoutTime: UILabel!
    @IBOutlet weak var sourceFrom: UILabel!
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var workoutIcon: UIImageView!
    var workout: HKWorkout!
    let healthManager = HealthManager.shared
    let setWorkHelper = setWorkCellData.shared
    var selectDate: Date?
    
    var note:[Note]=[]
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //如果沒按儲存直接返回
        if textField.text != "請輸入文字" && !textField.text.isEmpty {
            CoreDataHelper.shared.saveContext()
            self.textField.resignFirstResponder()
            self.textField.isEditable = false
            self.saveBtn.isHidden = true
            self.textField.textColor = UIColor.lightGray
        }
        tabBarController?.tabBar.isHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecord = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm " // 設置日期格式為小時:分鐘:秒
        
        
        
        let (image, title, caloriesBurnedString) = setWorkHelper.setCellIconandTitle(for: workout)
        
        //時間
        let startTime = workout.startDate
        let endTime = workout.endDate
        workoutTime.text = dateFormatter.string(from: startTime) + " - " + dateFormatter.string(from: endTime)
        
        //上方的定位，同時設定距離
        let totaldistance = workout.totalDistance
        
        healthManager.searchWorkOutData(workout) { locationinfo,error  in
            if let error = error {
                print("location fail: \(error)")
                return
            }
            DispatchQueue.main.async {
                if let locationinfo = locationinfo,
                   let totaldistance = totaldistance {
                    self.workoutLoaction.text = locationinfo
                    self.workoutLoaction.isHidden = false
                    self.locationIcon.isHidden = false
                    
                    let distance = totaldistance.doubleValue(for: HKUnit.meter()) / 1000.0
                    self.totalDistance.isHidden = false
                    self.distanceTitle.isHidden = false
                    self.totalDistance.text = String(format: "%.2f 公里",distance)
                }
                else {
                    self.workoutLoaction.isHidden = true
                    self.locationIcon.isHidden = true
                    self.totalDistance.isHidden = true
                    self.distanceTitle.isHidden = true
                }
                
            }
            
        }
        
        //心律
        healthManager.searchHeartRate(workout) { rate, error in
            if let error = error {
                print("searchHeartRate fail : \(error)")
                DispatchQueue.main.async {
                    self.averageRate.text = "-- 下 / 分"
                    
                }
                return
            }
            DispatchQueue.main.async {
                self.averageRate.text = String(format: "%.0f 下 / 分", rate ?? "-- 下 / 分")
            }
        }
        
        //上方的資料來源
        let sourceRevision = workout.sourceRevision
        let source = sourceRevision.source
        let deviceName = source.name
        sourceFrom.text = deviceName
        
        //下方的運動總時數
        let duringtime = setWorkHelper.formatTimeInterval(workout.duration)
        totalTime.text = duringtime
        
        workoutName.text = title
        totalCaro.text = caloriesBurnedString
        
        workoutIcon.image = image
        workoutIcon.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
        
        dataBackground.layer.cornerRadius = 5
        
        
        
        // In your viewDidLoad or setup code
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        textField.delegate = self
        textField.text = "請輸入文字"
        textField.textColor = UIColor.lightGray
        
        queryFromCoreData(forWorkout: workout)
        if let note = self.note.first { // 假設你只關心第一個符合條件的 Note
            textField.text = note.text
        }
       
        //NotificationCenter.default.addObserver(self, selector: #selector(setGoogleAds), name: .GoogleAds, object: nil)
        setGoogleAds()
    }
    
    func setGoogleAds() {
        self.bannerView = GADBannerView(adSize: GADAdSizeBanner)
        self.bannerView?.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView?.adUnitID = "ca-app-pub-9284244039295056/4603007338"
        //self.bannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716" //官方提供的測試ID
        self.bannerView?.delegate = self
        self.bannerView?.rootViewController = self
        self.bannerView?.load(GADRequest())
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // 點擊其他空白的地方時關閉鍵盤
        self.view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textField.text == "請輸入文字" {
            textField.text = nil
            textField.textColor = UIColor.black
            }
        else {
            textField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textField.text.isEmpty {
            textField.text = "請輸入文字"
            textField.textColor = UIColor.lightGray
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func startEditing(_ sender: Any) {
        textField.isEditable = true
        saveBtn.isHidden = false
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
        
    }
    @IBAction func saveContent(_ sender: Any) {
        let dateCoreData = DateFormatter()
        dateCoreData.dateFormat = "yyyy 年 MM 月 dd 日"
        let dateString = dateCoreData.string(from: selectDate!)
        // 獲取 ManagedObjectContext
            let moc = CoreDataHelper.shared.managedObjectContext()

            // 查詢現有的 Note，以便進行修改或創建新的
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.predicate = NSPredicate(format: "worOut == %@", workout)

            moc.performAndWait {
                do {
                    let notes = try moc.fetch(request)

                    if let existingNote = notes.first { // 如果已經存在 Note，則修改它
                        existingNote.text = textField.text
                    } else { // 否則，創建一個新的 Note
                        let newNote = Note(context: moc)
                        newNote.date = dateString
                        newNote.worOut = workout
                        newNote.text = textField.text
                    }

                    // 保存 ManagedObjectContext 中的更改
                    CoreDataHelper.shared.saveContext()
                } catch {
                    print("query or save coredata error \(error)")
                }
            }
        
        DispatchQueue.main.async {
                //更新畫面的程式
            self.textField.resignFirstResponder()
            self.textField.isEditable = false
            self.saveBtn.isHidden = true
            self.textField.textColor = UIColor.lightGray
        }
        
        
    }
    
    func queryFromCoreData(forWorkout workout: HKWorkout){
        //查詢
        let moc = CoreDataHelper.shared.managedObjectContext()
       
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.predicate = NSPredicate(format: "worOut == %@", workout)
        
        moc.performAndWait {
            
            do{
                let notes = try moc.fetch(request)
                self.note = notes
            }catch{
                self.note = []
                print("query coredata error \(error)")
            }
        }
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        //self.tableView.tableHeaderView = bannerView 廣告直接在table的最上面，但一滑動他就會不見
        
        if bannerView.superview == nil { //表示目前沒有貼任何廣告
            
            self.view.addSubview(bannerView) //把banner加到畫面上才可以設定autoLayout
            //2.重建constraint
            NSLayoutConstraint.activate([
                
                bannerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        }
    }
    
}
