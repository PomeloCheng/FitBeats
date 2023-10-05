//
//  logManager.swift
//  HelloMyChatRoom
//
//  Created by YuCheng on 2023/8/7.
//

import Foundation
import UIKit

class logImage {
    //典型的singtone
    static let shared = logImage()
    private init(){}
    
    // 添加 Timer 屬性
    private var purgeTimer: Timer?
    
    // 設定 Timer 間隔（例如，每天清除一次快取）
    private let purgeInterval: TimeInterval = 30 * 24 * 60 * 60 // 30天檢查一次
    
    //save & cache Photos 圖片的備份
    //從0開始的思維
    //會有儲存
    func save(data: Data, filename: String) throws {
        let finalFilenameURL = urlFor(filename: filename + ".png")
        //凡是跟檔案輸出有關的都會拋出error
        try data.write(to: finalFilenameURL)
    }
    //會有讀取
    func load(filename: String) -> UIImage? {
        //有可能本地端沒有這麼圖片 -> 傳回nil
        let finalFilenameURL = urlFor(filename: filename + ".png")
        return UIImage(contentsOfFile: finalFilenameURL.path)
        
        // URL < - > path 兩個可以互轉，沒有差異，看語法支援哪個
        //let url = URL(fileURLWithPath: <#T##String#>)
    }
    
    private func urlFor(filename: String) -> URL {
        //前面一整串幾乎是不會出錯的，所以可以放心用驚嘆號
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        //let finalFilenameURL = cacheURL.appendingPathComponent(filename, conformingTo: .image) 太新了
        //appendingPathComponent 很好用 -> 自動的把路徑跟檔名做適當的合併
        return cacheURL.appendingPathComponent(filename)
        // abc.com/abc + "/123.jpg"
        // abc.com/abc/ + "123.jpg"
        //appendingPathComponent會自動幫我們加斜線
        
    }
    
    // 開始計時器
    func startPurgeTimer() {
        // 創建 Timer，設置間隔和目標
        purgeTimer = Timer.scheduledTimer(timeInterval: purgeInterval, target: self, selector: #selector(purgeOldImages), userInfo: nil, repeats: true)
    }
    
    //真實產品可能還會考慮 - 清除
    @objc private func purgeOldImages() {
        let fileManager = FileManager.default
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let purgeThreshold: TimeInterval = 30 * 24 * 60 * 60 // 30 天的秒數
        let imageFileExtensions = ["jpg", "jpeg", "png", "gif", "bmp"] // 常見的圖片擴展名

        do {
            // 獲取快取目錄中的所有文件
            let directoryContents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [])

            for fileURL in directoryContents {
                do {
                    // 獲取文件的屬性，包括修改日期
                    let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)

                    if let modificationDate = fileAttributes[.modificationDate] as? Date {
                        // 檢查文件的修改日期是否超過指定的閾值
                        if modificationDate.timeIntervalSinceNow < -purgeThreshold {
                            // 檢查文件的擴展名是否是圖片擴展名之一
                            let fileExtension = fileURL.pathExtension.lowercased()
                            if imageFileExtensions.contains(fileExtension) {
                                // 如果超過閾值且是圖片文件，則刪除文件
                                try fileManager.removeItem(at: fileURL)
                            }
                            
                        }
                    }
                } catch {
                    // 處理錯誤，例如無法獲取文件屬性或刪除文件失敗
                    print("Error purging file: \(error)")
                }
            }
        } catch {
            // 處理錯誤，例如無法獲取快取目錄內容
            print("Error enumerating cache directory contents: \(error)")
        }
    }

    //聊天紀錄
    
    
    
    
    
}
