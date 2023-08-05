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
    
    //MARK: - Collection view
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return banners.count
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


