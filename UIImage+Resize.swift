//
//  UIImage+Resize.swift
//  HelloMyChatRoom
//
//  Created by YuCheng on 2023/8/1.
//

import Foundation
import UIKit

extension UIImage {
    func resize(maxEdge: CGFloat) -> UIImage? {
        //先檢查是否有必要縮圖
        if self.size.width <= maxEdge && self.size.height <= maxEdge {
            return self
        }
        
        //計算維持等比例的狀況下的最終大小
        let radio = self.size.width / self.size.height
        let finalSize : CGSize
        if self.size.width > self.size.height {
            let finalHeight = maxEdge / radio
            finalSize = CGSize(width: maxEdge, height: finalHeight)
        } else { // height >= width
            let finalWeight = maxEdge * radio
            finalSize = CGSize(width: finalWeight, height: maxEdge)
        }
        //輸出成新的UIImage
        
        //C語言的API 很底層的東西 -> 硬體加速
        //C語言 -> 要注意記憶體管理問題
        
        //幫我們形成一塊記憶體空間 -> 一個畫布
        //他沒有建立任何物件，就直接開始做事->通常是C層次的東西
        UIGraphicsBeginImageContext(finalSize)
        // 原點 0,0 , 指定 finalSize大小
        let rect = CGRect(origin: .zero, size: finalSize)
        // 把原圖影印在這個畫布上
        self.draw(in: rect)
        //把它輸出成結果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        //畫布還在，要記得關掉
        UIGraphicsEndImageContext() // Important
        return result
    }
}
