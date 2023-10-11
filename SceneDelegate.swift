//
//  SceneDelegate.swift
//  FitBeats
//
//  Created by YuCheng on 2023/7/31.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var lastUpdateDate: Date?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        checkAndUpdateTodayDate()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let window = UIWindow(windowScene: windowScene)
            
            var initialViewController: UIViewController
            
            if Auth.auth().currentUser == nil {
                // 用户未登录，显示登录视图控制器
                let phoneViewController = storyboard.instantiateViewController(withIdentifier: "PhoneViewController") as! PhoneViewController
                    initialViewController = UINavigationController(rootViewController: phoneViewController)
            } else {
                // 用户已登录，显示主屏幕视图控制器
                initialViewController = storyboard.instantiateViewController(withIdentifier: "mainScreen")
                if let userID = Auth.auth().currentUser?.uid {
                    UserDataManager.shared.currentUserUid = userID
                    UserDataManager.shared.fetchUserData()
                }
            }
            
            window.rootViewController = initialViewController
            self.window = window
            window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        checkAndUpdateTodayDate()
        
        
        if let mainVC = self.window?.visibleViewController as? mainRecordVC {


                calendarManager.shared.FSCalendar.currentPage = todayDate
                mainVC.updateDateTitle(todayDate)

                calendarManager.shared.resetSelectedState()
                calendarManager.shared.selectTodayWeekdayLabel()
                NotificationCenter.default.post(name: Notification.Name("reloadTableView"), object: nil)

            if appStart {
                DispatchQueue.main.async {
                    mainVC.calendarView.reloadData()
                }
            }
        } else if let mainVC = self.window?.visibleViewController as? homeViewController {
            calendarManager.shared.FSCalendar.currentPage = todayDate
            mainVC.updateDateTitle(todayDate)

            calendarManager.shared.resetSelectedState()
            calendarManager.shared.selectTodayWeekdayLabel()
            UserDataManager.shared.fetchUserData()
            increaseEnergy(home: mainVC)
            if appStart {
                DispatchQueue.main.async {
                    mainVC.calendarView.reloadData()
                }
            }
            
        } else {
            
            print("Visible view controller is not of type ViewController or homeViewController")
        }
    }
    
    func checkAndUpdateTodayDate() {
            // 获取当前日期
            let currentDate = Date()
            
            // 如果上次更新日期为空或者与当前日期不同
            if lastUpdateDate == nil || !Calendar.current.isDate(currentDate, inSameDayAs: lastUpdateDate!) {
                // 更新 todayDate 为当前日期
                todayDate = currentDate
                
                // 更新上次更新日期为当前日期
                lastUpdateDate = currentDate
            }
        }
    
    private func increaseEnergy(home: homeViewController) {
        // 在这里将能量值 X 增加 1234
        
        NotificationCenter.default.removeObserver(self, name: .updateMonster, object: nil)
        
        if  updateStep != 0 && updateCaro != 0 && updatePrgress != 0.0 {
        
            var increaseNumber = 0
            if updateStep < 1000 {
                increaseNumber = 0
            } else if updateStep < 2000 {
                increaseNumber = 1
            } else if updateStep < 3000 {
                increaseNumber = 2
            } else {
                increaseNumber = 3
            }
            NotificationCenter.default.post(name: .updateMonster, object: increaseNumber)
            
            if let userCaroPoint = UserDataManager.shared.currentUserData?["CaloriesPoints"] as? Int,
               let userCheckPoint = UserDataManager.shared.currentUserData?["CheckinPoints"] as? Int {
                let currentEnergy = userCaroPoint
                let newCaroPoint = currentEnergy + updateCaro
                
                
                UserDataManager.shared.currentUserData?["CaloriesPoints"] = newCaroPoint
                DispatchQueue.main.async {
                    home.homeCaroLabel.text = String(format: "%d", newCaroPoint)
                }
                UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CaloriesPoints", fieldValue: newCaroPoint)
                
                if updatePrgress >= 1 {
                    let currentCheckPoint = userCheckPoint
                    let newCheckPoint = currentCheckPoint + 1
                    
                    UserDataManager.shared.currentUserData?["CheckinPoints"] = newCheckPoint
                    DispatchQueue.main.async {
                        home.homeCheckLabel.text = String(format: "%d", newCheckPoint)
                    }
                    UserDataManager.shared.updateUserInfoInFirestore(fieldName: "CheckinPoints", fieldValue: newCheckPoint)
                }
            }
            
            
            updateStep = 0
            updateCaro = 0
            updatePrgress = 0.0
        }
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

