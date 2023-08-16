import UIKit

let userID = 3
let username = "John"
let phoneNumber = "0930444555"
let useruuid = UUID().uuidString
var checkPoint = 0


class ViewController: UIViewController,updateMoneyDelegate {
    
    var products: [Product] = []
    var histories: [History] = []
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        Communicator.shared.getPoints(userID: 3) { result in
            
            checkPoint = result.checkPoint
            DispatchQueue.main.async {
                self.pointLabel.text = "\(checkPoint)"
                self.collectionView.reloadData()
            }
        }
        Communicator.shared.getList(categoryID: 1){ result in

            if !result.isEmpty {
                self.products = result
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func testBtnPress(_ sender: Any) {
        checkPoint += 1000
        Communicator.shared.uploadPoints(userID: 3, newCheckPoint: checkPoint, newHeatPoint: 0) { result in
            switch result {
            case true:
                    DispatchQueue.main.async {
                    self.pointLabel.text = "\(checkPoint)"
                    }
                print("upload Success.")
            case false:
                print("error.")
            }
        }
    }
    func updateMoney(){
        pointLabel.text = "\(Int(checkPoint))"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let nextVC = segue.destination as? itemViewController,
               let indexPath = collectionView.indexPathsForSelectedItems?.first {
                
                // 根據 indexPath 取得點選的 cell 的資料
                let selectedProduct = products[indexPath.row]
                // 將資料傳遞給內頁
                nextVC.product = selectedProduct
                nextVC.updateMoneyDelegate = self
            }
        }
    }


extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        print("\(products[indexPath.row])")
    }
}


