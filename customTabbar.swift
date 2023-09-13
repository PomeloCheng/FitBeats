//
//  customTabbar.swift
//  FitBeats
//
//  Created by YuCheng on 2023/8/18.
//

import UIKit

class CustomTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureAppearance()
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedItemSpacing = 10
        self.scrollEdgeAppearance = appearance
    }
}
