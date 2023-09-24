//
//  ShopViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/8.
//

import UIKit

class ShopViewController: UIViewController, UINavigationControllerDelegate {
    

    
   
    @IBOutlet weak var topConstrant: NSLayoutConstraint!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    
    // Original height of the top view
    var viewHeight: CGFloat = 221
    // Keep track of the
    private var isAnimationInProgress = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 在進入內頁時隱藏導航欄
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if topHeightConstraint.constant <= 0 {
            topHeightConstraint.constant = viewHeight
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleScrollViewDidScroll(_:)), name: Notification.Name("ScrollViewDidScroll"), object: nil)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectItem), name: Notification.Name("pushView"), object: nil)
        
        
    }
    
    @objc func handleScrollViewDidScroll(_ notification: Notification) {
        // Check if the animation is locked or not
        if !isAnimationInProgress {
            
            
            guard let topHeightConstraint = topHeightConstraint,
                let verticalOffset = notification.object as? CGFloat
            else { return }
            
            // Check if an animation is required
            if verticalOffset > .zero &&
                topHeightConstraint.constant > .zero {
                
                topHeightConstraint.constant = .zero
                animateTopViewHeight()
            }
            else if verticalOffset <= .zero
                        && topHeightConstraint.constant <= .zero {
                
                topHeightConstraint.constant = viewHeight
                animateTopViewHeight()
            }
        }
    }
    
    // Animate the top view
    private func animateTopViewHeight() {
        
        // Lock the animation functionality
        isAnimationInProgress = true
        
        UIView.animate(withDuration: 0.15) {
            
            self.view.layoutIfNeeded()
            
        } completion: { [weak self] (_) in
            
            // Unlock the animation functionality
            self?.isAnimationInProgress = false
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
    
    
    @objc func didSelectItem(_ notification: Notification) {
        
        tabBarController?.tabBar.isHidden = true
        if let itemVC = storyboard?.instantiateViewController(withIdentifier: "itemViewController") as? itemViewController,
           let productInfo = notification.object as? [String: Any],
           let product = productInfo["selectedProduct"] as? fireBaseProduct,
           let categoryTag = productInfo["categoryTag"] as? Int {
            
            
            itemVC.fireProducts = product
            itemVC.categoryTag = categoryTag
            
            navigationController?.pushViewController(itemVC, animated: true)
            
            //topConstrant.constant = .zero
        }
            //self.view.layoutIfNeeded()
            
        
    }

    
    
    
}


    
    

