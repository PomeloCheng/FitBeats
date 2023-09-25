//
//  userPocketViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/9/24.
//

import UIKit
class handbookViewController: UIViewController {
    
    @IBOutlet weak var collectioViewHeigfht: NSLayoutConstraint!
    var isHomePresent = false
    @IBOutlet weak var presentNavgation: UINavigationBar!
    var maskView : UIView?
    var userPcoket: [String] = []
    var allPet : [fireBaseProduct] = []
    var selectPet: String?
    @IBOutlet weak var handBookCollectView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        handBookCollectView.dataSource = self
        handBookCollectView.delegate = self
        
        self.title = "怪物圖鑑"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let currentPocket = UserDataManager.shared.currentUserData?["ownedProducts"] as? [String] {
            self.userPcoket = currentPocket
        }
        
        ShopItemManager.shared.fetchProductData(categoryID: 0){ products in
            if let products = products {
                self.allPet = products
                DispatchQueue.main.async {
                    self.handBookCollectView.reloadData()
                }
            }
        }
        
        if isHomePresent {
            collectioViewHeigfht.constant = 60
            self.handBookCollectView.layoutIfNeeded()
            presentNavgation.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentNavgation.isHidden = true
        isHomePresent = false
        collectioViewHeigfht.constant = 0
        self.handBookCollectView.layoutIfNeeded()
    }
    
    @IBAction func closeMarkBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
}
extension handbookViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "handBook", for: indexPath) as! handBookCell
        let pocketPet = allPet[indexPath.row]
        
        print(userPcoket)
        
        // 检查当前商品是否在 userPet 中
        if userPcoket.contains(pocketPet.productsName) {
            cell.petImage.layer.opacity = 1.0
            cell.petImage.image = logImage.shared.load(filename: pocketPet.productsName)
            cell.petName.layer.opacity = 1.0
        } else {
            cell.petImage.layer.opacity = 0.2
            cell.petName.layer.opacity = 0.2
            if let image = logImage.shared.load(filename: pocketPet.productsName + "_n") {
               DispatchQueue.main.async {
                   cell.petImage.image = image
               }
            
            } else {
                ShopItemManager.shared.downloadProductsImage(imageURLString: pocketPet.grayImage) { imageData in
                    guard let imageData = imageData else {
                        return
                    }
                    let orginImage = UIImage(data:imageData)
                    let newimage = orginImage!.resize(maxEdge: 200)
                    do {
                        try logImage.shared.save(data: imageData, filename: pocketPet.productsName + "_n")
                    } catch {
                        print("write File error : \(error) ")
                        //建議不要print，用alert秀出來比較方便
                    }
                    DispatchQueue.main.async {
                        cell.petImage.image = newimage
                    }
                }
            }
        }
        
        cell.petName.text = pocketPet.productsName
        cell.petName.textColor = .black
        cell.petBG.backgroundColor = .white
        cell.petBG.layer.cornerRadius = 10
        cell.petBG.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.petBG.layer.shadowColor = UIColor.lightGray.cgColor
        cell.petBG.layer.shadowOpacity = 0.2
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.bounds.width
        let itemWidth = screenWidth / 2 - 32// 每一列顯示兩個項目
        let itemHeight: CGFloat = 200 // 設定固定的高度
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


