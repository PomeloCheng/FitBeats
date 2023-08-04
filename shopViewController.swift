//
//  shopViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/1.
//

import UIKit

class shopViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var time:Timer?
        //紀錄目前banner播放到第幾個cell
        var imageIndex = 0
        var banners = ["1","2","3","1"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
               
        pageControl.numberOfPages = banners.count - 1
        //pageControl.backgroundStyle = .prominent
        // Do any additional setup after loading the view.
        
        time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
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
    
    //MARK: - Collection view
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            banners.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            let indexPath = banners[indexPath.item]
            cell.bannerImageView.contentMode = .scaleAspectFit
            let orginImage = UIImage(named: "\(indexPath).jpg")
            cell.bannerImageView.image = orginImage?.resize(maxEdge: 393)
            
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return bannerCollectionView.bounds.size
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
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


