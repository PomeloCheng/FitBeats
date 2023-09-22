//
//  ChildController1.swift
//  XMLtest
//
//  Created by YuCheng on 2023/8/7.
//

import UIKit
import XLPagerTabStrip
protocol ShopContentDelegate: AnyObject {
    func didSelectItem(product: Product, navigationController: UINavigationController)
}

class shopContentVC: UIViewController,IndicatorInfoProvider {
    
    
    var fireProducts: [fireBaseProduct] = []
    var products: [Product] = []
    var histories: [History] = []
    @IBOutlet weak var shopContentView: UICollectionView!
    var categoryTag: Int = 0
    weak var delegate : ShopContentDelegate?
    var navigationControllerRef: UINavigationController?
    
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
            
            ShopItemManager.shared.fetchProductData(categoryID: 1){ products in
                if let products = products {
                    self.fireProducts = products
                    print("categoryID 1")
                    DispatchQueue.main.async {
                        self.shopContentView.reloadData()
                    }
                }
            }
//            Communicator.shared.getList(categoryID: 1){ result in
//
//                if !result.isEmpty {
//                    self.products = result
//                    DispatchQueue.main.async {
//                        self.shopContentView.reloadData()
//                    }
//                }
//            }
        case 1:
            ShopItemManager.shared.fetchProductData(categoryID: 2){ products in
                if let products = products {
                    self.fireProducts = products
                    print("categoryID 2")
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        NotificationCenter.default.post(name: Notification.Name("ScrollViewDidScroll"), object: scrollView.contentOffset.y)
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        NotificationCenter.default.post(name: Notification.Name("ScrollViewDidScroll"), object: scrollView.contentOffset.y)
//    }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PHPcell", for: indexPath) as! PHPCollectionViewCell
        let product = fireProducts[indexPath.row]
        cell.name.text = product.productsName
        cell.price.text = String(product.checkPointPrice)
        
        
        if let image = logImage.shared.load(filename: product.productsName) {
           DispatchQueue.main.async {
               cell.imageView.image = image
           }
        
        } else {
            ShopItemManager.shared.downloadProductsImage(imageURLString: product.image!) { imageData in
                guard let imageData = imageData else {
                    return
                }
                let orginImage = UIImage(data:imageData)
                let newimage = orginImage!.resize(maxEdge: 120)
                do {
                    try logImage.shared.save(data: imageData, filename: product.productsName)
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
//        guard let navigationController = navigationControllerRef else {
//            return
//        }
////        self.delegate?.didSelectItem(product: selectedProduct, navigationController: navigationController)
//        let userInfo: [String: Any] = ["product": selectedProduct, "navigationRef": navigationController]
        
        NotificationCenter.default.post(name: Notification.Name("pushView"), object: selectedProduct)
        
    }
    
}

