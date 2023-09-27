//
//  ChildController1.swift
//  XMLtest
//
//  Created by YuCheng on 2023/8/7.
//

import UIKit
import XLPagerTabStrip
class shopContentVC: UIViewController,IndicatorInfoProvider {
    
    
    var fireProducts: [fireBaseProduct] = []
    
    @IBOutlet weak var shopContentView: UICollectionView!
    var categoryTag: Int = 0
    
    var navigationControllerRef: UINavigationController?
    
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        switch categoryTag {
        case 1:
            return IndicatorInfo(title: "精選商品")
        case 2:
            return IndicatorInfo(title: "新品上市")
        case 3:
            return IndicatorInfo(title: "熱門選購")
        case 4:
            return IndicatorInfo(title: "特色寵物")
        
        default:
            return IndicatorInfo(title: "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopContentView.delegate = self
        shopContentView.dataSource = self
        
        switch categoryTag {
        case 1:
            
            ShopItemManager.shared.fetchProductData(categoryID: 1){ products in
                if let products = products {
                    self.fireProducts = products
                    
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }

        case 2:
            ShopItemManager.shared.fetchProductData(categoryID: 2){ products in
                if let products = products {
                    self.fireProducts = products
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }
        case 3:
            ShopItemManager.shared.fetchProductData(categoryID: 3){ products in
                if let products = products {
                    self.fireProducts = products
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }
        case 4:
            ShopItemManager.shared.fetchProductData(categoryID: 1){ products in
                if let products = products {
                    self.fireProducts = products
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }
        default:
            break
        }
        // Do any additional setup after loading the view.
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        NotificationCenter.default.post(name: Notification.Name("ScrollViewDidScroll"), object: scrollView.contentOffset.y)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let nextVC = segue.destination as? itemViewController,
               let indexPath = shopContentView.indexPathsForSelectedItems?.first {
                
                // 根據 indexPath 取得點選的 cell 的資料
                let selectedProduct = fireProducts[indexPath.row]
                // 將資料傳遞給內頁
                nextVC.fireProducts = selectedProduct
                
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
        return fireProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHPcell", for: indexPath) as! shopCollectionViewCell
        let product = fireProducts[indexPath.row]
        cell.name.text = product.productName
        if categoryTag == 1 {
            cell.price.text = String(product.checkinPoints)
            cell.iconView.image = UIImage(named: "home_recommend_icon.png")
        }
        else {
            cell.price.text = String(product.caloriesPoints)
            cell.iconView.image = UIImage(named: "home_hot_icon.png")
        }
        
        if let image = logImage.shared.load(filename: product.productName) {
           DispatchQueue.main.async {
               cell.imageView.image = image
           }
        
        } else {
            ShopItemManager.shared.downloadProductsImage(imageURLString: product.image) { imageData in
                guard let imageData = imageData else {
                    return
                }
                let orginImage = UIImage(data:imageData)
                let newimage = orginImage!.resize(maxEdge: 200)
                do {
                    try logImage.shared.save(data: imageData, filename: product.productName)
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
        
       let selectedProduct = fireProducts[indexPath.row]
        
        let productInfo : [String: Any] = ["selectedProduct": selectedProduct, "categoryTag": categoryTag]

        NotificationCenter.default.post(name: Notification.Name("pushView"), object: productInfo)
        
    }
    
}

