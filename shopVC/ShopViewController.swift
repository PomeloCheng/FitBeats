//
//  ShopViewController.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/8.
//

import UIKit

class ShopViewController: UIViewController {
    

    
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    // Original height of the top view
    var viewHeight: CGFloat = 221
    // Keep track of the
    private var isAnimationInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleScrollViewDidScroll(_:)), name: Notification.Name("ScrollViewDidScroll"), object: nil)
        // Do any additional setup after loading the view.
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
            
            UIView.animate(withDuration: 0.2) {
                
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
}
