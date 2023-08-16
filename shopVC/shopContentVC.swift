//
//  ChildController1.swift
//  XMLtest
//
//  Created by YuCheng on 2023/8/7.
//

import UIKit
import XLPagerTabStrip


class shopContentVC: UIViewController,IndicatorInfoProvider {
    
    
    
    var products: [Product] = []
    var histories: [History] = []
    @IBOutlet weak var shopContentView: UICollectionView!
    var categoryTag: Int = 0

    
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        switch categoryTag {
        case 0:
            return IndicatorInfo(title: "Item One")
        case 1:
            return IndicatorInfo(title: "Item Two")
        
        default:
            return IndicatorInfo(title: "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopContentView.delegate = self
        shopContentView.dataSource = self
        
        switch categoryTag {
        case 0:
            Communicator.shared.getPoints(userID: 3) { result in
                
                checkPoint = result.checkPoint
                DispatchQueue.main.async {
                    self.shopContentView.reloadData()
                }
            }
            Communicator.shared.getList(categoryID: 1){ result in

                if !result.isEmpty {
                    self.products = result
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }
        case 1:
            shopContentView.backgroundColor = .red
        default:
            shopContentView.backgroundColor = .white
        }
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: Notification.Name("ScrollViewDidScroll"), object: nil, userInfo: ["contentOffsetY": scrollView.contentOffset.y])
    }
    
    @IBAction func testBtnPress(_ sender: Any) {
        checkPoint += 1000
        Communicator.shared.uploadPoints(userID: 3, newCheckPoint: checkPoint, newHeatPoint: 0) { result in
            switch result {
            case true:
                    DispatchQueue.main.async {
                    }
                print("upload Success.")
            case false:
                print("error.")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let nextVC = segue.destination as? itemViewController,
               let indexPath = shopContentView.indexPathsForSelectedItems?.first {
                
                // 根據 indexPath 取得點選的 cell 的資料
                let selectedProduct = products[indexPath.row]
                // 將資料傳遞給內頁
                nextVC.product = selectedProduct
                
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

}

extension shopContentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHPcell", for: indexPath) as! PHPCollectionViewCell
        let product = products[indexPath.row]
        cell.name.text = product.productsName
        cell.price.text = String(product.checkPointPrice)
        
        //下載檢查
        if let image = logImage.shared.load(filename: product.productsName) {
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
            
            print("* Load from cache: \(product.productsName)") //方便我們自己觀察真的從快取讀出來的
            return cell
        }
        
        
        if let imageURL = product.image{
            Communicator.shared.downloadPhoto(fileURL: imageURL) { data in
                guard let data = data else {
                    return
                }
                let orginImage = UIImage(data:data)
                let newimage = orginImage!.resize(maxEdge: 120)
                do {
                    try logImage.shared.save(data: data, filename: product.productsName)
                } catch {
                    print("write File error : \(error) ")
                    //建議不要print，用alert秀出來比較方便
                }
                DispatchQueue.main.async {
                    cell.imageView.image = newimage
                }
                
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width
        let itemWidth = screenWidth / 2 - 24// 每一列顯示兩個項目
        let itemHeight: CGFloat = 200 // 設定固定的高度
                
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "shop", bundle: nil)
            if let itemVC = storyboard.instantiateViewController(withIdentifier: "itemViewController") as? itemViewController {
                // 設置 itemVC 需要的數據或內容
                navigationController?.pushViewController(itemVC, animated: true)
            }
        
    }
}

