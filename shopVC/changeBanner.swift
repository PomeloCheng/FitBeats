//
//  changeBanner.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/5.
//

import UIKit

extension shopViewController {
    
    @objc func changeBanner(){
            
            var indexPath:IndexPath
            
            //imageIndex加一轉動圖片到下一張
            imageIndex += 1

            //在banner陣列裡再加入第一筆圖片名稱，當不是最後一筆資料時
            if imageIndex < banners.count{

                //用imageIndex去產生一個indexPath
                indexPath = IndexPath(item: imageIndex, section: 0)
                //讓collectionView去選indexPath
                bannerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                
                pageControl.currentPage = imageIndex
                //當imageIndex是banner陣列裡的最後一筆資料時，將page control設為0，是第一張圖也是第一個page control圈圈
                if imageIndex == banners.count - 1{
                    pageControl.currentPage = 0
                }
                
            }
            else
            {
                //當banner數量等於banner陣列的最後一筆資料，回到第一筆資料，page control也回到第一個圈
                imageIndex = 0
                pageControl.currentPage = 0
                indexPath = IndexPath(item: imageIndex, section: 0)
                //不要動畫先回到第一張圖
                bannerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                
                //再重新輪播
                changeBanner()
            }
            
        }
}
