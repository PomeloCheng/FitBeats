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
    
    //save & cache Photos 圖片的備份
    //從0開始的思維
    //會有儲存
    func save(data: Data, filename: String) throws {
        let finalFilenameURL = urlFor(filename: filename)
        //凡是跟檔案輸出有關的都會拋出error
        try data.write(to: finalFilenameURL)
    }
    //會有讀取
    func load(filename: String) -> UIImage? {
        //有可能本地端沒有這麼圖片 -> 傳回nil
        let finalFilenameURL = urlFor(filename: filename)
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
    
    //真實產品可能還會考慮 - 清除
//    func purge(){
//        //刪除以下載超過90天的圖片
//    }
    //聊天紀錄
    
    
    
    
    
}
